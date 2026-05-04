if Link.inventory ~= 'gs-inventory' and Link.inventory ~= 'gs_inventory' then
    return
end

local function getInvItems(player)
    local inv = exports['gs-inventory']:GetInventory(player)
    if not inv or not inv.items then return {} end
    return inv.items
end

function GetPlayerInventory(player)
    return NormalizeInventoryOutput(getInvItems(player))
end

function GetPlayerItemData(player, item)
    local items = getInvItems(player)
    local total = 0
    local first = nil
    for _, slot in pairs(items) do
        if slot and slot.name == item then
            total = total + (slot.count or 0)
            if not first then first = slot end
        end
    end
    if not first then return nil end
    return {
        name = item,
        count = total,
        amount = total,
        metadata = first.metadata or {},
    }
end

function GetPlayerItemCount(player, item)
    local data = GetPlayerItemData(player, item)
    if not data then return 0 end
    return data.count or data.amount or 0
end

function AddPlayerItem(player, item, amount, meta)
    local ok = exports['gs-inventory']:AddItem(player, item, amount or 1, meta, nil)
    return ok == true
end

function RemovePlayerItem(player, item, amount)
    return exports['gs-inventory']:RemoveItem(player, item, amount or 1, nil) == true
end

function OpenCustomStash(player, stashId, label, slots, weight)
    exports['gs-inventory']:GetOrCreateStash(tostring(stashId), {
        label = label or 'Storage',
        slots = slots or 50,
        maxWeight = weight or 100000,
    })
    TriggerClientEvent('kq_link:client:gs-inventory:openStash', player, tostring(stashId), label, slots, weight)
end

function GetStashItems(stashId)
    local stash = exports['gs-inventory']:GetStash(tostring(stashId))
    if not stash or not stash.items then return {} end
    return stash.items
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

-- Slot-level API (native GetSlot; SetMetadata via gs-inventory export)
function GetInventoryItems(player)
    return GetPlayerInventory(player) or {}
end

function SetMetadata(player, slotId, metadata)
    local inv = exports['gs-inventory']:Inventory(player)
    if not inv then
        return nil
    end
    local sid = tonumber(slotId) or slotId
    return exports['gs-inventory']:SetMetadata(inv, sid, metadata)
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
    local slot = exports['gs-inventory']:GetSlot(player, slotId)
    if not slot or not slot.name then return nil end
    slot.count = slot.count or slot.amount
    slot.metadata = slot.metadata or {}
    slot.slot = slot.slot or slotId
    return slot
end
