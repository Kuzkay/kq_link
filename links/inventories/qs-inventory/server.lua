if Link.inventory ~= 'qs-inventory' and Link.inventory ~= 'qs' then
    return
end

function GetPlayerInventory(player)
    return exports['qs-inventory']:GetInventory(player)
end

function RegisterUsableItem(...)
    exports['qs-inventory']:CreateUsableItem(...)
end

function GetPlayerItemData(player, item)
    local data = exports['qs-inventory']:GetItemTotalAmount(player, item)
    return { amount = data }
end

function GetPlayerItemCount(player, item)
    return exports['qs-inventory']:GetItemTotalAmount(player, item) or 0
end

function AddPlayerItem(player, item, amount, meta)
    return exports['qs-inventory']:AddItem(player, item, amount, nil, meta)
end

function RemovePlayerItem(player, item, amount)
    if GetPlayerItemCount(player, item) < amount then
        return false
    end
    
    return exports['qs-inventory']:RemoveItem(player, item, amount, nil, meta)
end

-- Stashes
local stashes = {}
function OpenCustomStash(player, stashId, label, slots, weight)
    stashId = ('stash_' .. stashId):gsub('-', '_')
    
    if not stashes[stashId] then
        exports['qs-inventory']:RegisterStash(player, stashId, slots, weight)
        stashes[stashId] = true
    end
    
    TriggerClientEvent('kq_link:client:qs-inventory:openStash', player, stashId, {maxweight = weight, slots = slots})
end

function GetStashItems(stashId)
    stashId = ('stash_' .. stashId):gsub('-', '_')

    return exports['qs-inventory']:GetStashItems(stashId)
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
