if Link.framework ~= 'none' and Link.framework ~= 'standalone' then
    return
end

function GetPlayersWithJob(jobs)
    return {}
end

function CanPlayerAfford(player, amount)
    return true
end

function AddPlayerMoney(player, amount, account)
    return true
end

function RemovePlayerMoney(player, amount)
    return true
end

function GetPlayerItemData(player, item)
    return nil
end

function GetPlayerItemCount(player, item)
    return 1000
end

function AddPlayerItem(player, item, amount, meta)
    return true
end

function RemovePlayerItem(player, item, amount)
    return true
end

function GetPlayerCharacterId(player)
    return GetPlayerIdentifierByType(player, 'license')
end

function RegisterUsableItem(...)
    return true -- This system doesn't have it
end

function OpenCustomStash()
    -- Not available in standalone
    return true
end

function GetStashItems()
    -- Not available in standalone
    return {}
end
