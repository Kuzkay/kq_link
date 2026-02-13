if Link.inventory ~= 'codem-inventory' and Link.inventory ~= 'codem' then
    return
end

--Unsure if this implementation is correct
function GetPlayerInventory(player)
    local identifier = GetPlayerIdentifierByType(player, 'license')
    return exports['codem-inventory']:GetInventory(identifier, source)
end

function GetPlayerItemData(player, item)
    local data = exports['codem-inventory']:GetItemsByName(player, item)
    return data or {}
end

function GetPlayerItemCount(player, item)
    return exports['codem-inventory']:GetItemsTotalAmount(player, item)
end

function AddPlayerItem(player, item, amount, meta)
    return exports['codem-inventory']:AddItem(player, item, amount, nil, meta)
end

function RemovePlayerItem(player, item, amount)
    return exports['codem-inventory']:RemoveItem(player, item, amount, nil)
end


-- Stashes
function OpenCustomStash(player, stashId, label, slots, weight)
    TriggerClientEvent('kq_link:client:codem-inventory:openStash', player, stashId, weight, slots)
end

function GetStashItems(stashId)
    return exports['codem-inventory']:GetStashItems(stashId)
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
--
