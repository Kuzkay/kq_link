if Link.inventory ~= 'ox_inventory' and Link.inventory ~= 'ox' then
    return
end

function GetPlayerItemData(player, item)
    local data = exports['ox_inventory']:GetItem(player, item)
    return data or {}
end

function GetPlayerItemCount(player, item)
    local data = GetPlayerItemData(player, item)
    return data.count or data.amount or 0
end

function AddPlayerItem(player, item, amount, meta)
    local success, response = exports['ox_inventory']:AddItem(player, item, amount or 1, meta)
    return success
end

function RemovePlayerItem(player, item, amount)
    local success, response = exports['ox_inventory']:RemoveItem(player, item, amount or 1)
    return success
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
