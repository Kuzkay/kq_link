if Link.inventory ~= 'jaksam_inventory' and Link.inventory ~= 'jaksam' then
    return
end

-- jaksam getInventory returns { id, label, items = { ["SLOT-1"] = { name, amount, metadata }, ... } }; we need items keyed by numeric slot
function GetPlayerInventory(player)
    local inv = exports['jaksam_inventory']:getInventory(player)
    if not inv or not inv.items then return {} end
    local bySlot = {}
    for slotKey, item in pairs(inv.items) do
        local num = tonumber((tostring(slotKey):match('(%d+)')) or slotKey)
        if num and item and item.name then
            bySlot[num] = item
        end
    end
    return NormalizeInventoryOutput(bySlot)
end

function GetPlayerItemData(player, item, meta)
    local data, slotId = exports['jaksam_inventory']:getItemByName(player, item, meta)
    return data or {}
end

function GetPlayerItemCount(player, item, meta)
    local count = exports['jaksam_inventory']:getTotalItemAmount(player, item, meta)
    return count or 0
end

function AddPlayerItem(player, item, amount, meta)
    local success, response = exports['jaksam_inventory']:addItem(player, item, amount or 1, meta)
    return success
end

function RemovePlayerItem(player, item, amount, meta)
    local success, response = exports['jaksam_inventory']:removeItem(player, item, amount or 1, meta)
    return success
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

-- Stashes
local stashes = {}
function OpenCustomStash(player, stashId, label, slots, weight)
    if not stashes[stashId] then
        exports['jaksam_inventory']:registerStash({
            id = stashId,
            label = label or stashId,
            maxSlots = slots or 50,
            maxWeight = weight or 100000,
            runtimeOnly = true
        })
        stashes[stashId] = true
    end

    exports['jaksam_inventory']:forceOpenInventory(player, stashId)
end

function GetStashItems(stashId)
    if not stashes[stashId] then
        return {}
    end

    local inventory = exports['jaksam_inventory']:getInventory(stashId)
    return inventory and inventory.items or {}
end

-- Slot-level API: use native jaksam exports where documented (getItemFromSlot, setItemMetadataInSlot)
function GetInventoryItems(player)
    return GetPlayerInventory(player) or {}
end

function GetItemSlots(player, itemName)
    local inv = GetPlayerInventory(player) or {}
    local slots = {}
    local total = 0
    for slot, item in pairs(inv) do
        if item and item.name == itemName and (item.count or item.amount or 0) > 0 then
            local s = item.slot or slot
            slots[s] = item.count or item.amount or 1
            total = total + (item.count or item.amount or 1)
        end
    end
    return slots, total
end

function GetSlot(player, slotId)
    local item = exports['jaksam_inventory']:getItemFromSlot(player, slotId)
    if not item or not item.name then return nil end
    item.slot = slotId
    item.count = item.count or item.amount
    item.metadata = item.metadata or item.meta
    return item
end

function SetMetadata(player, slotId, metadata)
    local success = exports['jaksam_inventory']:setItemMetadataInSlot(player, slotId, metadata or {})
    return success
end
