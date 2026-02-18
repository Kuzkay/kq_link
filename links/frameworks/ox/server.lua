if Link.framework ~= 'ox' and Link.framework ~= 'ox_core' then
    return
end

function GetPlayerJob(player)
    -- Not implemented by framework
    return '', ''
end

function GetPlayersWithJob(jobs)
    -- Not implemented by framework
    return {}
end

function CanPlayerAfford(player, amount)
    if Link.inventory == "ox_inventory" then
        if exports.ox_inventory:GetItemCount(player, "cash", amount) >= amount then
            return true
        end
    end

    local OxPlayer = Ox.GetPlayer(player)

    if OxPlayer then
        local OxAccount = OxPlayer.getAccount()

        if OxAccount then
            return OxAccount.get("balance") >= amount
        end
    end

    return false
end

function AddPlayerMoney(player, amount, account)
    if Link.inventory == "ox_inventory" and account == "cash" then
        local success, _ = exports.ox_inventory:AddItem(player, "cash", cashAmount)

        if success then
            return true
        end
    end

    local OxPlayer = Ox.GetPlayer(player)

    if OxPlayer then
        local OxAccount = OxPlayer.getAccount()

        if OxAccount then
            return account.addBalance({ amount = cashAmount }).success
        end
    end

    return false
end

function RemovePlayerMoney(player, cashAmount)
    if Link.inventory == "ox_inventory" then
        local success, _ = exports.ox_inventory:RemoveItem(player, "cash", cashAmount)

        if success then
            return true
        end
    end

    local OxPlayer = Ox.GetPlayer(player)

    if OxPlayer then
        local OxAccount = OxPlayer.getAccount()

        if OxAccount then
            return account.removeBalance({ amount = cashAmount, overdraw = false }).success
        end
    end

    return false
end

if Link.inventory == 'framework' then
    Link.inventory = 'ox_inventory'
end

function GetPlayerCharacterId(player)
    local xPlayer = Ox.GetPlayer(tonumber(player))

    if not xPlayer then
        return nil
    end

    return xPlayer.charId
end

function GetPlayerCharacterName(player)
    local xPlayer = Ox.GetPlayer(tonumber(player))
    if not xPlayer then
        return GetPlayerName(player) or 'Unknown'
    end

    local firstName = xPlayer.firstName
    local lastName = xPlayer.lastName

    if firstName and lastName then
        return firstName .. ' ' .. lastName
    end

    return GetPlayerName(player) or 'Unknown'
end

-- OX uses ox_inventory by default, weapon functions defined in inventory file

function RegisterUsableItem(...)
    return true -- This system doesn't have it
end
