if Link.inventory ~= 'core_inventory' and Link.inventory ~= 'core' then
    return
end

function GetPlayerInventory(player)
    return NormalizeInventoryOutput(exports['core_inventory']:getInventory(player))
end

function GetPlayerItemData(player, item)
    local data = exports['core_inventory']:getItem(player, item)
    return data or {}
end

function GetPlayerItemCount(player, item)
    local data = GetPlayerItemData(player, item)
    return data.count or data.amount or 0
end

function AddPlayerItem(player, item, amount, meta)
    local success, response = exports['core_inventory']:addItem(player, item, amount or 1, meta)
    return success
end

function RemovePlayerItem(player, item, amount)
    local success, response = exports['core_inventory']:removeItem(player, item, amount or 1)
    return success
end

-- Stashes
function OpenCustomStash(player, stashId, label, slots, weight)
    exports['core_inventory']:openInventory(player, ('stash-' .. stashId):gsub(' ', ''), 'stash', 300, 300, true, nil, false)
end

function GetStashItems(stashId)
    return exports['core_inventory']:getInventory( ('stash-' .. stashId):gsub(' ', ''))
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
