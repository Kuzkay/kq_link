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

function RemovePlayerMoney(player, cashAmount, account)
    if Link.inventory == "ox_inventory" and (not account or account == "cash") then
        local success, _ = exports.ox_inventory:RemoveItem(player, "cash", cashAmount)
        if success then return true end
    end

    local OxPlayer = Ox.GetPlayer(player)
    if not OxPlayer then return false end
    local OxAccount = OxPlayer.getAccount()
    if not OxAccount or not OxAccount.removeBalance then return false end
    local result = OxAccount.removeBalance({ amount = cashAmount, overdraw = false })
    return result and result.success
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

function GetPlayerMoney(player, account)
    local OxPlayer = Ox.GetPlayer(tonumber(player))
    if not OxPlayer then return 0 end
    local OxAccount = OxPlayer.getAccount()
    if not OxAccount then return 0 end
    local balance = OxAccount.get and OxAccount.get("balance")
    return type(balance) == 'number' and balance or 0
end

function GetSourceFromCharacterId(identifier)
    if not identifier then return nil end
    for _, id in ipairs(GetPlayers()) do
        local src = tonumber(id)
        if src and GetPlayerCharacterId(src) == identifier then
            return src
        end
    end
    return nil
end

-- OX uses ox_inventory by default, weapon functions defined in inventory file

function RegisterUsableItem(...)
    return true -- This system doesn't have it
end
