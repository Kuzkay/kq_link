if Link.framework ~= 'esx' and Link.framework ~= 'es_extended' then
    return
end

ESX = nil

if not Link.esx.useOldExport then
    ESX = exports['es_extended']:getSharedObject()
else
    TriggerEvent('esx:getSharedObject', function(obj)
        ESX = obj
    end)
end

function GetPlayersWithJob(jobs)
    local matchingPlayers = {}
    local players = GetPlayers()
    local isTable = type(jobs) == 'table'
    
    for _, playerId in ipairs(players) do
        local src = tonumber(playerId)
        local xPlayer = ESX.GetPlayerFromId(src)
        local job = xPlayer and xPlayer.job and xPlayer.job.name
        
        if job then
            if isTable then
                for _, name in ipairs(jobs) do
                    if job == name then
                        table.insert(matchingPlayers, src)
                        break
                    end
                end
            elseif job == jobs then
                table.insert(matchingPlayers, src)
            end
        end
    end
    
    return matchingPlayers
end


function CanPlayerAfford(player, amount)
    local xPlayer = ESX.GetPlayerFromId(player)

    if xPlayer.getAccount('money').money >= amount then
        return true
    end

    if xPlayer.getAccount('bank').money >= amount then
        return true
    end

    return false
end

function AddPlayerMoney(player, amount, account)
    local xPlayer = ESX.GetPlayerFromId(player)
    if not xPlayer then
        return false
    end

    return xPlayer.addAccountMoney(account or 'money', amount)
end

function RemovePlayerMoney(player, amount)
    local xPlayer = ESX.GetPlayerFromId(player)
    if not xPlayer then
        return false
    end

    if not CanPlayerAfford(player, amount) then
        return false
    end

    if xPlayer.getAccount('money').money >= amount then
        xPlayer.removeAccountMoney('money', amount)
        return true
    end

    if xPlayer.getAccount('bank').money >= amount then
        xPlayer.removeAccountMoney('bank', amount)
        return true
    end

    return false
end

function RegisterUsableItem(...)
    ESX.RegisterUsableItem(...)
end

if Link.inventory == 'framework' then
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
    
    function OpenCustomStash()
        -- Not available in base framework inv
        return true
    end
    
    function GetStashItems()
        -- Not available in standalone
        return {}
    end
end

function GetPlayerCharacterId(player)
    local xPlayer = ESX.GetPlayerFromId(player)

    return xPlayer.identifier
end
