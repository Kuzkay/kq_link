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

function GetPlayerJob(player)
    local xPlayer = ESX.GetPlayerFromId(player)
    local job = xPlayer and xPlayer.job and xPlayer.job.name
    local grade = xPlayer and xPlayer.job and xPlayer.job.grade

    return job, grade
end

function GetPlayersWithJob(jobs, minGrade)
    minGrade = minGrade or 0

    local matchingPlayers = {}
    local added = {}

    local isTable = type(jobs) == 'table'
    local jobList = isTable and jobs or { jobs }

    for _, jobName in ipairs(jobList) do
        local jobPlayers = ESX.GetExtendedPlayers('job', jobName) or {}

        for _, xPlayer in ipairs(jobPlayers) do
            local src = tonumber(xPlayer.source)
            if src and not added[src] then
                local job, grade = GetPlayerJob(src)
                if job == jobName and grade >= minGrade then
                    added[src] = true
                    matchingPlayers[#matchingPlayers + 1] = src
                end
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
end

function GetPlayerCharacterId(player)
    local xPlayer = ESX.GetPlayerFromId(player)

    return xPlayer.identifier
end

function GetPlayerCharacterName(player)
    local xPlayer = ESX.GetPlayerFromId(player)
    if not xPlayer then
        return GetPlayerName(player) or 'Unknown'
    end

    local firstName = xPlayer.get('firstName')
    local lastName = xPlayer.get('lastName')

    if firstName and lastName then
        return firstName .. ' ' .. lastName
    end

    return xPlayer.getName() or GetPlayerName(player) or 'Unknown'
end
