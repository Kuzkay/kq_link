if Link.inventory ~= 'qs-inventory' and Link.inventory ~= 'qs' then
    return
end

function GetPlayerInventory(player)
    return NormalizeInventoryOutput(exports['qs-inventory']:GetInventory(player))
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

-- Slot-level API (compatibility for scripts like gs-phone)
function GetInventoryItems(player)
    return GetPlayerInventory(player) or {}
end

function GetItemSlots(player, itemName)
    local inv = GetPlayerInventory(player) or {}
    local slots = {}
    local total = 0
    for slot, item in pairs(inv) do
        if item and item.name == itemName and (item.count or 0) > 0 then
            local s = item.slot or slot
            slots[s] = item.count or 1
            total = total + (item.count or 1)
        end
    end
    return slots, total
end

function GetSlot(player, slotId)
    local inv = GetPlayerInventory(player) or {}
    if inv[slotId] and inv[slotId].name then return inv[slotId] end
    for _, item in pairs(inv) do
        if item and (item.slot or nil) == slotId then return item end
    end
    return nil
end
