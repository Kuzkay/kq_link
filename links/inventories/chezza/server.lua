print('chezza inventory server loaded')
print()
if Link.inventory ~= 'chezza' and Link.inventory ~= 'chezza' then
    return
end

stahes = {}

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
print('openCustomStash', stashId, label, slots, weight)
if not stashes[stashId] then
    print("Opening stash:" .. stashId .. " with label: " .. label)

    identifier = ESX.GetPlayerFromId(player).getIdentifier()
    print("identifier: " .. identifier)
    print("stashId: " .. stashId)
    print("label: " .. label)
    TriggerClientEvent('inventory:openHouse', player, identifier, stashId, label, 3000)
print("Opening stash with data: " .. identifier .. ", " .. stashId .. ", " .. label .. ", " .. 3000)

    -- TriggerEvent('inventory:openHouse', stash, "house-1", "House Title", 300)


    TriggerClientEvent('inventory:openInventory', client {
        type = "stash",
        id = stashId,
        title = label,
        weight = weight or false,
        delay = 100,
        save = true
    })
    print("opened Stash")
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