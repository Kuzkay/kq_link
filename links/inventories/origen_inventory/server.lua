if Link.inventory ~= 'origen_inventory' and Link.inventory ~= 'origen' then
    return
end

function RegisterUsableItem(...)
    exports['origen_inventory']:CreateUseableItem(...)
end

function GetPlayerItemData(player, item)
    local data = exports['origen_inventory']:GetItem(player, item)
    return data or {}
end

function GetPlayerItemCount(player, item)
    local data = GetPlayerItemData(player, item)
    return data.count or data.amount or 0
end

function AddPlayerItem(player, item, amount, meta)
    local success, response = exports['origen_inventory']:AddItem(player, item, amount or 1, meta)
    return success
end

function RemovePlayerItem(player, item, amount)
    local success, response = exports['origen_inventory']:RemoveItem(player, item, amount or 1)
    return success
end

-- Stashes
local stashes = {}
function OpenCustomStash(player, stashId, label, slots, weight)
    if not stashes[stashId] then
        exports['origen_inventory']:RegisterStash(stashId, {
            label = label,
            slots = slots or 50,
            weight = weight or 100000
        })
        
        stashes[stashId] = true
    end
    
    exports['origen_inventory']:OpenInventory(player, 'stash', stashId)
end

function GetStashItems(stashId)
    if not stashes[stashId] then
        return {}
    end
    
    return exports['origen_inventory']:GetStashItems(stashId)
end
--
