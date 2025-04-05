if Link.framework ~= 'qbox' and Link.framework ~= 'qbx' and Link.framework ~= 'qbx-core' then
    return
end

QBX = exports['qb-core']:GetCoreObject()

function GetPlayersWithJob(jobs)
    local matchingPlayers = {}
    local players = GetPlayers()
    local isTable = type(jobs) == 'table'
    
    for _, playerId in ipairs(players) do
        local src = tonumber(playerId)
        local xPlayer = exports.qbx_core:GetPlayer(src)
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
