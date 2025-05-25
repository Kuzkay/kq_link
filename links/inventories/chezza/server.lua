if Link.inventory ~= 'chezza' then
    return
end

stashes = {}

function GetPlayerItemData(player, item)
    local xPlayer = ESX.GetPlayerFromId(player)

    return xPlayer.getInventoryItem(item)
end

function GetPlayerItemCount(player, item)
    local data = GetPlayerItemData(player, item)
    if not data then
        return 0
    end
    return data.count or data.amount or 0
end

function AddPlayerItem(player, item, amount, meta)
    local xPlayer = ESX.GetPlayerFromId(player)

    if xPlayer.canCarryItem(item, amount or 1) then
        xPlayer.addInventoryItem(item, amount or 1, meta)
        return true
    else
        return false
    end
end

function RemovePlayerItem(player, item, amount)
    if GetPlayerItemCount(player, item) < amount then
        return false
    end
    
    local xPlayer = ESX.GetPlayerFromId(player)
    xPlayer.removeInventoryItem(item, amount or 1)
    
    return true
end

function OpenCustomStash(player, stashId, label, slots, weight)

if not stashes[stashId] then

    -- statshes dont work for some reason it wont open twice
    -- TriggerClientEvent('inventory:openInventory', player, {
    --     type = "stash",
    --     id = stashId,
    --     title = label,
    --     weight = weight or 3000,
    --     delay = 100,
    --     save = true
    -- })
    -- stashes[stashId] = true
    xPlayer = ESX.GetPlayerFromId(player)
    TriggerClientEvent('inventory:openHouse', xPlayer.source, xPlayer.identifier, stashId, label, weight)
    end
end

function GetStashItems(stashId)
    if not stashes[stashId] then
        return {}
    end
    local xPlayer = ESX.GetPlayerFromId(src)
    local inventory = exports.inventory:getInventory(xPlayer, inv)
    
    return {}
end

--
