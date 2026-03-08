if Link.inventory ~= 'ak47_inventory' and Link.inventory ~= 'ak47' then
    return
end

function GetPlayerInventory(player)
    return NormalizeInventoryOutput(exports['ak47_inventory']:GetInventory(player))
end

function GetPlayerItemData(player, item)
    local data = exports['ak47_inventory']:GetItem(player, item)
    return data or {}
end

function GetPlayerItemCount(player, item)
    local data = GetPlayerItemData(player, item)
    return data.count or data.amount or 0
end

function AddPlayerItem(player, item, amount, meta)
    local success, response = exports['ak47_inventory']:AddItem(player, item, amount or 1, nil)
    return success
end

function RemovePlayerItem(player, item, amount)
    local success, response = exports['ak47_inventory']:RemoveItem(player, item, amount or 1)
    return success
end

-- Stashes
local stashes = {}
function OpenCustomStash(player, stashId, label, slots, weight)
    if not stashes[stashId] then
        exports['ak47_inventory']:LoadInventory(stashId, {
            label = label,
            maxWeight = weight or 100000,
            maxSlots = slots or 50,
            type = 'stash',
        })
        
        stashes[stashId] = true
    end
    
    exports['ak47_inventory']:OpenInventory(player, stashId)
end

function GetStashItems(stashId)
    if not stashes[stashId] then
        return {}
    end

    return exports['ak47_inventory']:GetInventoryItems(stashId)
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
