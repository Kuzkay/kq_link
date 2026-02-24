if Link.inventory ~= 'chezza' then
    return
end

function GetPlayerInventory(player)
    local xPlayer = ESX.GetPlayerFromId(player)
    local inv = {
        type = 'player',
        id = xPlayer.identifier -- assuming that's how the inventory system works
    }

    return NormalizeInventoryOutput(exports.inventory:getInventory(xPlayer, inv) or {})
end

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
    xPlayer = ESX.GetPlayerFromId(player)
    TriggerClientEvent('inventory:openHouse', xPlayer.source, xPlayer.identifier, stashId, label, weight)
    
    return true
end

function GetStashItems(stashId)
    -- not possible with this system
    return {}
end

function AddPlayerWeapon(player, weapon, ammo)
    local xPlayer = ESX.GetPlayerFromId(player)
    if not xPlayer then
        return false
    end

    xPlayer.addWeapon(weapon, ammo or 0)
    return true
end

function DoesPlayerHaveWeapon(player, weapon)
    local xPlayer = ESX.GetPlayerFromId(player)
    if not xPlayer then
        return false
    end

    return xPlayer.hasWeapon(weapon)
end

function RemovePlayerWeapon(player, weapon)
    local xPlayer = ESX.GetPlayerFromId(player)
    if not xPlayer then
        return false
    end

    xPlayer.removeWeapon(weapon)
    return true
end
--
