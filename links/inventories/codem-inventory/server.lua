if Link.inventory ~= 'codem-inventory' and Link.inventory ~= 'codem' then
    return
end

function GetPlayerInventory(player)
    local identifier = GetPlayerIdentifierByType(player, 'license')
    return NormalizeInventoryOutput(exports['codem-inventory']:GetInventory(identifier, player) or {})
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

-- Slot-level API: use native CodeM exports (GetItemBySlot, SetItemMetadata) per codem.gitbook.io
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
    local item = exports['codem-inventory']:GetItemBySlot(player, slotId)
    if not item or not item.name then return nil end
    item.slot = item.slot or slotId
    item.count = item.count or item.amount
    item.metadata = item.metadata or item.info or item.meta
    return item
end

function SetMetadata(player, slotId, metadata)
    exports['codem-inventory']:SetItemMetadata(player, slotId, metadata or {})
    return true
end
