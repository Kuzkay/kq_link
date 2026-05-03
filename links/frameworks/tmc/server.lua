if Link.framework ~= 'tmc' then
    return
end

TMC = exports.core:getCoreObject()

function GetPlayerJob(player)
    local xPlayer = TMC.Functions.GetPlayer(tonumber(player))
    local job, grade = xPlayer.Functions.IsOnDuty()
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

        if job and grade and grade >= minGrade then
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
    local xPlayer = TMC.Functions.GetPlayer(player)
    if xPlayer.Functions.GetMoney('cash') >= amount then
        return true
    end
    if xPlayer.Functions.GetMoney('bank') >= amount then
        return true
    end
    return false
end

function AddPlayerMoney(player, amount, account)
    local xPlayer = TMC.Functions.GetPlayer(player)
    if not xPlayer then
        return false
    end
    return xPlayer.Functions.AddMoney('cash', amount, "Job Payment")
end

function RemovePlayerMoney(player, amount)
    local xPlayer = TMC.Functions.GetPlayer(player)
    if not CanPlayerAfford(player, amount) then
        return false
    end
    if xPlayer.Functions.GetMoney('cash') >= amount then
        xPlayer.Functions.RemoveMoney('cash', amount, "Job Payment")
        return true
    end
    if xPlayer.Functions.GetMoney('bank') >= amount then
        xPlayer.Functions.RemoveMoney('bank', amount, "Job Payment")
        return true
    end
    return false
end

function RegisterUsableItem(...)
    TMC.Functions.CreateUseableItem(...)
end

if Link.inventory == 'framework' or Link.inventory == 'tmc-inventory' then
    function GetPlayerItemData(player, item)
        local xPlayer = TMC.Functions.GetPlayer(player)
        local data    = xPlayer.Functions.GetItemByName(item)
        return data
    end

    function GetPlayerItemCount(player, item)
        local xPlayer = TMC.Functions.GetPlayer(player)
        return xPlayer.Functions.GetItemAmountByName(item)
    end

    function AddPlayerItem(player, item, amount, meta)
        local xPlayer = TMC.Functions.GetPlayer(tonumber(player))
        return xPlayer.Functions.AddItem(item, amount or 1)
    end

    function RemovePlayerItem(player, item, amount)
        local xPlayer = TMC.Functions.GetPlayer(tonumber(player))
        return xPlayer.Functions.RemoveItem(item, amount or 1)
    end

    -- Stash
    function OpenCustomStash(player, stashId, label, slots, weight)
        local invData = {
            title = label,
            slotCount = slots,
            maxWeight = weight
        }

        exports.inventory:openInventory(player, stashId, invData)
    end

    function GetStashItems(stashId)
        local items = exports.inventory:getStashItems(stashId)
        return items or {}
    end

    function AddPlayerWeapon(player, weapon, ammo)
        return AddPlayerItem(player, weapon, 1, { ammo = ammo or 0 })
    end

    function DoesPlayerHaveWeapon(player, weapon)
        return GetPlayerItemCount(player, weapon) > 0
    end

    function RemovePlayerWeapon(player, weapon)
        return RemovePlayerItem(player, weapon, 1)
    end
end

function GetPlayerCharacterId(player)
    local xPlayer = TMC.Functions.GetPlayer(tonumber(player))

    if not xPlayer or not xPlayer.PlayerData then
        return nil
    end

    return xPlayer.PlayerData.citizenid
end

function GetPlayerCharacterName(player)
    local xPlayer = TMC.Functions.GetPlayer(tonumber(player))
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