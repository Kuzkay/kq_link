if Link.inventory ~= 'ox_inventory' and Link.inventory ~= 'ox' then
    return
end

function GetPlayerItemData(player, item, meta)
    local data = exports['ox_inventory']:GetItem(player, item, meta)
    return data or {}
end

function GetPlayerItemCount(player, item, meta)
    local data = GetPlayerItemData(player, item)
    return data.count or data.amount or 0
end

function AddPlayerItem(player, item, amount, meta)
    local success, response = exports['ox_inventory']:AddItem(player, item, amount or 1, meta)
    return success
end

function RemovePlayerItem(player, item, amount)
    amount = amount or 1
    
    local items = exports['ox_inventory']:Search(player, 'slots', item)
    if not items or #items == 0 then
        return false
    end

    local total = 0
    for _, itemData in ipairs(items) do
        total = total + itemData.count
    end
    if total < amount then return false end

    local metadata = {}
    local remaining = amount

    for _, itemData in ipairs(items) do
        if remaining <= 0 then break end

        local remove = math.min(itemData.count, remaining)
        if exports['ox_inventory']:RemoveItem(player, item, remove, itemData.metadata, itemData.slot) then
            for i = 1, remove do
                table.insert(metadata, itemData.metadata or {})
            end
            remaining = remaining - remove
        end
    end

    return remaining == 0, metadata or {}
end

-- Stashes
local stashes = {}
function OpenCustomStash(player, stashId, label, slots, weight)
    if not stashes[stashId] then
        exports.ox_inventory:RegisterStash(stashId, label, slots or 50, weight or 100000)
        stashes[stashId] = true
    end

    TriggerClientEvent('kq_link:client:ox_inventory:openStash', player, stashId)
end

function GetStashItems(stashId)
    if not stashes[stashId] then
        return {}
    end

    return exports.ox_inventory:GetInventoryItems(stashId)
end
--
