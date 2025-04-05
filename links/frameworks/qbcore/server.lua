if Link.framework ~= 'qb-core' and Link.framework ~= 'qbcore' then
    return
end

QBCore = exports['qb-core']:GetCoreObject()

function GetPlayersWithJob(jobs)
    local matchingPlayers = {}
    local players = GetPlayers()
    local isTable = type(jobs) == 'table'
    
    for _, playerId in ipairs(players) do
        local src = tonumber(playerId)
        local xPlayer = QBCore.Functions.GetPlayer(src)
        local job = xPlayer and xPlayer.PlayerData and xPlayer.PlayerData.job and xPlayer.PlayerData.job.name
        
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

function RegisterUsableItem(...)
    QBCore.Functions.CreateUseableItem(...)
end

if Link.inventory == 'framework' or Link.inventory == 'qb-inventory' then
    function GetPlayerItemData(player, item)
        local xPlayer = QBCore.Functions.GetPlayer(player)
        
        local data    = xPlayer.Functions.GetItemByName(item)
        return data
    end
    
    function GetPlayerItemCount(player, item)
        local data = GetPlayerItemData(player, item)
        if not data then
            return 0
        end
        return data.amount or data.count or 0
    end
    
    function AddPlayerItem(player, item, amount, meta)
        local xPlayer = QBCore.Functions.GetPlayer(tonumber(player))
        return xPlayer.Functions.AddItem(item, amount or 1)
    end
    
    function RemovePlayerItem(player, item, amount)
        local xPlayer = QBCore.Functions.GetPlayer(tonumber(player))
        return xPlayer.Functions.RemoveItem(item, amount or 1)
    end
    
    -- Stash
    function OpenCustomStash(player, stashId, label, slots, weight)
        local data = { label = label, maxweight = weight, slots = slots }
        exports['qb-inventory']:OpenInventory(player, stashId, data)
    end
    
    function GetStashItems(stashId)
        local invData = exports['qb-inventory']:GetInventory(stashId)
        if invData == nil or invData == {} then
            return {}
        end
        return invData.items
    end
end

function GetPlayerCharacterId(player)
    local xPlayer = QBCore.Functions.GetPlayer(tonumber(player))
    
    return xPlayer.PlayerData.citizenid
end
