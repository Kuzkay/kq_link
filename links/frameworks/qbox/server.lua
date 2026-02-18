if Link.framework ~= 'qbox' and Link.framework ~= 'qbx' and Link.framework ~= 'qbx-core' then
    return
end


function GetPlayerJob(player)
    local xPlayer = exports.qbx_core:GetPlayer(player)
    local job = xPlayer and xPlayer.PlayerData.job and xPlayer.PlayerData.job.name
    local grade = xPlayer and xPlayer.PlayerData.job and xPlayer.PlayerData.job.grade and xPlayer.PlayerData.job.grade.level

    return job, grade
end

function GetPlayersWithJob(jobs, minGrade)
    local matchingPlayers = {}
    local players = GetPlayers()
    local isTable = type(jobs) == 'table'
    minGrade = minGrade or 0

    for _, playerId in ipairs(players) do
        local src = tonumber(playerId)
        local job, grade = GetPlayerJob(src)

        if job and grade then
            if isTable then
                for _, name in ipairs(jobs) do
                    if job == name and grade >= minGrade then
                        table.insert(matchingPlayers, src)
                        break
                    end
                end
            elseif job == jobs and grade >= minGrade then
                table.insert(matchingPlayers, src)
            end
        end
    end

    return matchingPlayers
end

function CanPlayerAfford(player, amount)
    if exports.qbx_core:GetMoney(player, 'cash') >= amount then
        return true
    end

    if exports.qbx_core:GetMoney(player, 'bank') >= amount then
        return true
    end

    return false
end

function AddPlayerMoney(player, amount, account)
    local xPlayer = exports.qbx_core:GetPlayer(player)

    if not xPlayer then
        return false
    end

    return xPlayer.Functions.AddMoney(account or 'cash', amount)
end

function RemovePlayerMoney(player, amount)
    if not CanPlayerAfford(player, amount) then
        return false
    end

    if exports.qbx_core:GetMoney(player, 'cash') >= amount then
        exports.qbx_core:RemoveMoney(player, 'cash', amount)
        return true
    end

    if exports.qbx_core:GetMoney(player, 'bank') >= amount then
        exports.qbx_core:RemoveMoney(player, 'bank', amount)
        return true
    end

    return false
end

if Link.inventory == 'framework' then
    Link.inventory = 'ox_inventory'
end

function GetPlayerCharacterId(player)
    local xPlayer = exports.qbx_core:GetPlayer(tonumber(player))

    if not xPlayer or not xPlayer.PlayerData then
        return nil
    end

    return xPlayer.PlayerData.citizenid
end

function GetPlayerCharacterName(player)
    local xPlayer = exports.qbx_core:GetPlayer(tonumber(player))
    if not xPlayer or not xPlayer.PlayerData or not xPlayer.PlayerData.charinfo then
        return GetPlayerName(player) or 'Unknown'
    end

    local charinfo = xPlayer.PlayerData.charinfo
    local firstName = charinfo.firstname
    local lastName = charinfo.lastname

    if firstName and lastName then
        return firstName .. ' ' .. lastName
    end

    return GetPlayerName(player) or 'Unknown'
end

-- QBox uses ox_inventory by default, weapon functions defined in inventory file

function RegisterUsableItem(...)
    return true -- This system doesn't have it
end
