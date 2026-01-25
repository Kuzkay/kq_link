if Link.framework ~= 'none' and Link.framework ~= 'standalone' then
    return
end

function GetPlayerJob(player)
    return '', ''
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

function GetPlayerCharacterName(player)
    return GetPlayerName(player) or 'Unknown'
end

function AddPlayerWeapon(player, weapon, ammo)
    GiveWeaponToPed(GetPlayerPed(player), weapon, ammo or 0, false, true)
    return true
end

function DoesPlayerHaveWeapon(player, weapon)
    return GetSelectedPedWeapon(GetPlayerPed(player)) == GetHashKey(weapon)
end

function RemovePlayerWeapon(player, weapon)
    RemoveWeaponFromPed(GetPlayerPed(player), GetHashKey(weapon))
    return true
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
