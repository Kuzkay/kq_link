if Link.inventory ~= 'jaksam_inventory' and Link.inventory ~= 'jaksam' then
    return
end

function GetPlayerInventory(player)
    return NormalizeInventoryOutput(exports['jaksam_inventory']:getInventory(player))
end

function GetPlayerItemData(player, item, meta)
    local data, slotId = exports['jaksam_inventory']:getItemByName(player, item, meta)
    return data or {}
end

function GetPlayerItemCount(player, item, meta)
    local count = exports['jaksam_inventory']:getTotalItemAmount(player, item, meta)
    return count or 0
end

function AddPlayerItem(player, item, amount, meta)
    local success, response = exports['jaksam_inventory']:addItem(player, item, amount or 1, meta)
    return success
end

function RemovePlayerItem(player, item, amount, meta)
    local success, response = exports['jaksam_inventory']:removeItem(player, item, amount or 1, meta)
    return success
end

-- Stashes
local stashes = {}
function OpenCustomStash(player, stashId, label, slots, weight)
    if not stashes[stashId] then
        exports['jaksam_inventory']:registerStash({
            id = stashId,
            label = label or stashId,
            maxSlots = slots or 50,
            maxWeight = weight or 100000,
            runtimeOnly = true
        })
        stashes[stashId] = true
    end

    exports['jaksam_inventory']:forceOpenInventory(player, stashId)
end

function GetStashItems(stashId)
    if not stashes[stashId] then
        return {}
    end

    local inventory = exports['jaksam_inventory']:getInventory(stashId)
    return inventory and inventory.items or {}
end
--
