if Link.framework ~= 'qb-core' and Link.framework ~= 'qbcore' then
    return
end

QBCore = exports['qb-core']:GetCoreObject()

function CanPlayerAfford(player, amount)
    local xPlayer = QBCore.Functions.GetPlayer(player)
    
    if xPlayer.Functions.GetMoney('cash') >= amount then
        return true
    end
    
    if xPlayer.Functions.GetMoney('bank') >= amount then
        return true
    end
    
    return false
end

function AddPlayerMoney(player, amount, account)
    local xPlayer = QBCore.Functions.GetPlayer(player)
    
    if not xPlayer then
        return false
    end
    
    return xPlayer.Functions.AddMoney(account or 'cash', amount)
end

function RemovePlayerMoney(player, amount)
    local xPlayer = QBCore.Functions.GetPlayer(player)
    
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
    function RegisterUsableItem(...)
        QBCore.Functions.CreateUseableItem(...)
    end
    
    function GetPlayerItemData(player, item)
        local xPlayer = QBCore.Functions.GetPlayer(player)
        
        local data    = xPlayer.Functions.GetItemByName(item)
        return data
    end
    
    function GetPlayerItemCount(player, item)
        local data = GetPlayerItemData(player, item)
        return data and (data.amount or data.count)
    end
    
    function AddPlayerItem(player, item, amount, meta)
        local xPlayer = QBCore.Functions.GetPlayer(tonumber(player))
        return xPlayer.Functions.AddItem(item, amount or 1)
    end
    
    function RemovePlayerItem(player, item, amount)
        local xPlayer = QBCore.Functions.GetPlayer(tonumber(player))
        return xPlayer.Functions.RemoveItem(item, amount or 1)
    end
end

function GetPlayerCharacterId(player)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(player))
    
    return xPlayer.PlayerData.citizenid
end