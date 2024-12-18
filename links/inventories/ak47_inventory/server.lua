if Link.inventory ~= 'ak47_inventory' and Link.inventory ~= 'ak47' then
    return
end

function GetPlayerItemData(player, item)
    local data = exports['ak47_inventory']:GetItem(player, item)
    return data or {}
end

function GetPlayerItemCount(player, item)
    local data = GetPlayerItemData(player, item)
    return data.count or data.amount or 0
end

function AddPlayerItem(player, item, amount, meta)
    local success, response = exports['ak47_inventory']:AddItem(player, item, amount or 1, nil)
    return success
end

function RemovePlayerItem(player, item, amount)
    local success, response = exports['ak47_inventory']:RemoveItem(player, item, amount or 1)
    return success
end

-- Stashes
local stashes = {}
function OpenCustomStash(player, stashId, label, slots, weight)
    if not stashes[stashId] then
        exports['ak47_inventory']:LoadInventory(stashId, {
            label = label,
            maxWeight = weight or 100000,
            maxSlots = slots or 50,
            type = 'stash',
        })
        
        stashes[stashId] = true
    end
    
    exports['ak47_inventory']:OpenInventory(player, stashId)
end

function GetStashItems(stashId)
    if not stashes[stashId] then
        return {}
    end
    
    return exports['ak47_inventory']:GetInventoryItems(stashId)
end
--
