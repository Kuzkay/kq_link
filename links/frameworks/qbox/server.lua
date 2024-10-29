if Link.framework ~= 'qbox' and Link.framework ~= 'qbx' and Link.framework ~= 'qbx-core' then
    return
end

QBX = exports['qb-core']:GetCoreObject()

function CanPlayerAfford(player, amount)
    local xPlayer = QBX.GetPlayer(player)
    
    if xPlayer.Functions.GetMoney('cash') >= amount then
        return true
    end
    
    if xPlayer.Functions.GetMoney('bank') >= amount then
        return true
    end
    
    return false
end

function AddPlayerMoney(player, amount, account)
    local xPlayer = QBX.GetPlayer(player)
    
    if not xPlayer then
        return false
    end
    
    return xPlayer.Functions.AddMoney(account or 'cash', amount)
end

function RemovePlayerMoney(player, amount)
    local xPlayer = QBX.GetPlayer(player)
    
    if not CanPlayerAfford(player, amount) then
        return false
    end
    
    if xPlayer.Functions.GetMoney('cash') >= amount then
        xPlayer.Functions.RemoveMoney('cash', amount)
        return true
    end
    
    if xPlayer.Functions.GetMoney('bank') >= amount then
        xPlayer.Functions.RemoveMoney('bank', amount)
        return true
    end
    
    return false
end

if Link.inventory == 'framework' then
    Link.inventory = 'ox_inventory'
end

function GetPlayerCharacterId(player)
    local xPlayer = QBX.GetPlayer(tonumber(player))
    
    return xPlayer.PlayerData.citizenid
end

function RegisterUsableItem(...)
    return true -- This system doesn't have it
end
