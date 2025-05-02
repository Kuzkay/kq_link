if Link.inventory ~= 'chezza' and Link.inventory ~= 'chezza' then
    return
end



function GetPlayerItemData(player, item)
    -- test
return {}
end

function GetPlayerItemCount(player, item)
    print('GetPlayerItemCount', player, item)
    -- local data = GetPlayerItemData(player, item)
    count = 0
        
    local inventory = exports.inventory:getInventory(xPlayer, inv)

    if not inventory then
        return 0
    end

    for k,v in pairs(inventory) do
        if v.name == item then
           count = count + count
        end
    end
    print('GetPlayerItemCount', player, item, count)


    return count
end

function AddPlayerItem(player, item, amount, meta)
    xPlayer = ESX.GetPlayerFromId(player)
 xPlayer.addInventoryItem(item, amount or 1, meta)
    return true
end

function RemovePlayerItem(player, item, amount)
  xPlayer = ESX.GetPlayerFromId(player)
  xPlayer.removeInventoryItem(item, amount or 1)
    return true
end

-- Stashes
local stashes = {}
function OpenCustomStash(player, stashId, label, slots, weight)
    -- if not stashes[stashId] then
    --     exports['ak47_inventory']:LoadInventory(stashId, {
    --         label = label,
    --         maxWeight = weight or 100000,
    --         maxSlots = slots or 50,
    --         type = 'stash',
    --     })
        
    --     stashes[stashId] = true
    -- end
    
    -- exports['ak47_inventory']:OpenInventory(player, stashId)

if not stashes[stashId] then
    TriggerEvent('inventory:openStorage', label, stashId, 100, 1000, {})
    stashes[stashId] = true
end
end

function GetStashItems(stashId)
    if not stashes[stashId] then
        return {}
    end
    
    return {}
end
--
