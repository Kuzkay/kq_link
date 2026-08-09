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

local ACCOUNT_ALIASES = {
    money = 'cash',
    wallet = 'cash',
    dirty_money = 'cash',
    black_money = 'cash',
    dirty = 'cash',
    black = 'cash',
    marked_bills = 'cash',
    markedbills = 'cash',
}

local function ParseAccount(account)
    if not account then
        return nil
    end

    return ACCOUNT_ALIASES[account] or account
end

function CanPlayerAfford(player, amount, account)
    account = ParseAccount(account)

    if Link.inventory == "ox_inventory" and account ~= "bank" then
        if exports.ox_inventory:GetItemCount(player, "cash") >= amount then
            return true
        end

        if account == "cash" then
            return false
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
    account = ParseAccount(account)

    if Link.inventory == "ox_inventory" and account == "cash" then
        local success, _ = exports.ox_inventory:AddItem(player, "cash", amount)

        if success then
            return true
        end
    end

    local OxPlayer = Ox.GetPlayer(player)

    if OxPlayer then
        local OxAccount = OxPlayer.getAccount()

        if OxAccount then
            return OxAccount.addBalance({ amount = amount }).success
        end
    end

    return false
end

function RemovePlayerMoney(player, amount, account)
    account = ParseAccount(account)

    if Link.inventory == "ox_inventory" and account ~= "bank" then
        local success, _ = exports.ox_inventory:RemoveItem(player, "cash", amount)

        if success then
            return true
        end

        if account == "cash" then
            return false
        end
    end

    local OxPlayer = Ox.GetPlayer(player)

    if OxPlayer then
        local OxAccount = OxPlayer.getAccount()

        if OxAccount then
            return OxAccount.removeBalance({ amount = amount, overdraw = false }).success
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
