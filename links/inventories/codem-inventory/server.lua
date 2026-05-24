if Link.inventory ~= 'codem-inventory' and Link.inventory ~= 'codem' then
    return
end

function GetPlayerInventory(player)
    local identifier = GetPlayerIdentifierByType(player, 'license')
    return NormalizeInventoryOutput(exports['codem-inventory']:GetInventory(identifier, player))
end

function GetPlayerItemData(player, item, meta)
    local items = exports['codem-inventory']:GetItemsByName(player, item)
    if not items or #items == 0 then
        return nil
    end

    if not meta then
        return items[1]
    end

    for _, itemData in ipairs(items) do
        local match = true
        local itemMeta = itemData.info or itemData.metadata or {}
        for k, v in pairs(meta) do
            if itemMeta[k] ~= v then
                match = false
                break
            end
        end
        if match then return itemData end
    end
    return nil
end

function GetPlayerItemCount(player, item, meta)
    if not meta then
        return exports['codem-inventory']:GetItemsTotalAmount(player, item) or 0
    end

    local items = exports['codem-inventory']:GetItemsByName(player, item)
    if not items or #items == 0 then
        return 0
    end

    local count = 0
    for _, itemData in ipairs(items) do
        local match = true
        local itemMeta = itemData.info or itemData.metadata or {}
        for k, v in pairs(meta) do
            if itemMeta[k] ~= v then
                match = false
                break
            end
        end
        if match then count = count + (itemData.amount or itemData.count or 1) end
    end
    return count
end

function AddPlayerItem(player, item, amount, meta)
    return exports['codem-inventory']:AddItem(player, item, amount, nil, meta)
end

function RemovePlayerItem(player, item, amount, meta)
    amount = amount or 1

    local items = exports['codem-inventory']:GetItemsByName(player, item)
    if not items or #items == 0 then
        return false
    end

    local slots = {}
    local total = 0

    for _, itemData in ipairs(items) do
        local match = true
        if meta then
            local itemMeta = itemData.info or itemData.metadata or {}
            for k, v in pairs(meta) do
                if itemMeta[k] ~= v then
                    match = false
                    break
                end
            end
        end
        if match then
            table.insert(slots, itemData)
            total = total + (itemData.amount or itemData.count or 1)
        end
    end

    if total < amount then return false end

    local metadata = {}
    local remaining = amount

    for _, itemData in ipairs(slots) do
        if remaining <= 0 then break end
        local remove = math.min(itemData.amount or itemData.count or 1, remaining)

        if exports['codem-inventory']:RemoveItem(player, item, remove, itemData.slot) then
            for i = 1, remove do
                table.insert(metadata, itemData.info or itemData.metadata or {})
            end
            remaining = remaining - remove
        end
    end

    return remaining == 0, metadata
end

function SetItemDurability(player, slot, durability)
    return exports['codem-inventory']:SetItemMetadata(player, slot, { durability = durability })
end

function GetItemBySlot(player, slot)
    return exports['codem-inventory']:GetItemBySlot(player, slot)
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
