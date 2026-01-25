if Link.inventory ~= 'tgiann-inventory' and Link.inventory ~= 'tgiann' then
    return
end

function GetPlayerItemData(player, item, meta)
    local data = exports['tgiann-inventory']:GetItem(player, item, meta, false)
    return data or {}
end

function GetPlayerItemCount(player, item, meta)
    return exports['tgiann-inventory']:GetItem(player, item, meta, true) or 0
end

function AddPlayerItem(player, item, amount, meta)
    local success, response = exports['tgiann-inventory']:AddItem(player, item, amount or 1, nil, meta)
    return success
end

function RemovePlayerItem(player, item, amount)
    amount = amount or 1

    local slots = exports['tgiann-inventory']:Search(player, 'slots', item)
    if not slots or #slots == 0 then
        return false
    end

    local itemDataList = {}
    local total = 0
    
    for _, slot in ipairs(slots) do
        local itemData = exports['tgiann-inventory']:GetItemBySlot(player, slot)
        
        if itemData and itemData.name == item then
            table.insert(itemDataList, itemData)
            total = total + itemData.amount
        end
    end
    
    if total < amount then return false end

    local metadata = {}
    local remaining = amount

    for _, itemData in ipairs(itemDataList) do
        if remaining <= 0 then break end

        local remove = math.min(itemData.amount, remaining)
       
        if exports['tgiann-inventory']:RemoveItem(player, item, remove, itemData.slot, itemData.metadata) then
            -- Collect metadata for each individual item removed
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
        exports['tgiann-inventory']:RegisterStash(stashId, label, slots or 50, weight or 100000)
        stashes[stashId] = true
    end

    TriggerClientEvent('kq_link:client:tgiann-inventory:openStash', player, stashId)
end

function GetStashItems(stashId)
    return {} -- Does not seem possible with Tgiann
end

function AddPlayerWeapon(player, weapon, ammo)
    return AddPlayerItem(player, weapon, 1, { ammo = ammo or 0 })
end

function DoesPlayerHaveWeapon(player, weapon)
    return GetPlayerItemCount(player, weapon) > 0
end

function RemovePlayerWeapon(player, weapon)
    return RemovePlayerItem(player, weapon, 1)
end
--
