if Link.inventory ~= 'ak47_inventory' and Link.inventory ~= 'ak47' then
    return
end

function GetPlayerInventory(player)
    return NormalizeInventoryOutput(exports['ak47_inventory']:GetInventory(player))
end

function GetPlayerItemData(player, item, meta)
    return exports['ak47_inventory']:GetItem(player, item, meta, meta ~= nil)
end

function GetPlayerItemCount(player, item, meta)
    local count = exports['ak47_inventory']:Search(player, 'count', item, meta)
    return count or 0
end

function AddPlayerItem(player, item, amount, meta)
    local success, response = exports['ak47_inventory']:AddItem(player, item, amount or 1, nil, meta)
    return success
end

function RemovePlayerItem(player, item, amount, meta)
    amount = amount or 1

    local slots = exports['ak47_inventory']:Search(player, 'slots', item, meta)
    if not slots or #slots == 0 then
        return false
    end

    local total = 0
    for _, slotData in ipairs(slots) do
        total = total + (slotData.count or slotData.amount or 1)
    end
    if total < amount then return false end

    local metadata = {}
    local remaining = amount

    for _, slotData in ipairs(slots) do
        if remaining <= 0 then break end
        local remove = math.min(slotData.count or slotData.amount or 1, remaining)

        if exports['ak47_inventory']:RemoveItem(player, item, remove, slotData.slot) then
            for i = 1, remove do
                table.insert(metadata, slotData.metadata or slotData.info or {})
            end
            remaining = remaining - remove
        end
    end

    return remaining == 0, metadata
end

function SetItemDurability(player, slot, durability)
    local success, response = exports['ak47_inventory']:SetQuality(player, slot, durability)
    return success
end

function GetItemBySlot(player, slot)
    return exports['ak47_inventory']:GetSlot(player, slot)
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
--
