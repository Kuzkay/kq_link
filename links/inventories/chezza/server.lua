if Link.inventory ~= 'chezza' then
    return
end

function GetPlayerInventory(player)
    local xPlayer = ESX.GetPlayerFromId(player)
    if not xPlayer then
        return {}
    end

    local inv = {
        type = 'player',
        id = xPlayer.identifier
    }

    return NormalizeInventoryOutput(exports.inventory:getInventory(xPlayer, inv) or {})
end

function GetPlayerItemData(player, item, meta)
    local xPlayer = ESX.GetPlayerFromId(player)
    if not xPlayer then
        return nil
    end

    if not meta then
        return xPlayer.getInventoryItem(item)
    end

    local inventory = xPlayer.getInventory()
    for _, itemData in ipairs(inventory) do
        if itemData.name == item then
            local match = true
            local itemMeta = itemData.metadata or itemData.meta or {}
            for k, v in pairs(meta) do
                if itemMeta[k] ~= v then
                    match = false
                    break
                end
            end
            if match then return itemData end
        end
    end
    return nil
end

function GetPlayerItemCount(player, item, meta)
    local xPlayer = ESX.GetPlayerFromId(player)
    if not xPlayer then
        return 0
    end

    if not meta then
        local data = xPlayer.getInventoryItem(item)
        return data and (data.count or data.amount or 0) or 0
    end

    local inventory = xPlayer.getInventory()
    local count = 0
    for _, itemData in ipairs(inventory) do
        if itemData.name == item then
            local match = true
            local itemMeta = itemData.metadata or itemData.meta or {}
            for k, v in pairs(meta) do
                if itemMeta[k] ~= v then
                    match = false
                    break
                end
            end
            if match then count = count + (itemData.count or itemData.amount or 1) end
        end
    end
    return count
end

function AddPlayerItem(player, item, amount, meta)
    local xPlayer = ESX.GetPlayerFromId(player)
    if not xPlayer then
        return false
    end

    if xPlayer.canCarryItem(item, amount or 1) then
        xPlayer.addInventoryItem(item, amount or 1, meta)
        return true
    end
    return false
end

function RemovePlayerItem(player, item, amount, meta)
    amount = amount or 1
    local xPlayer = ESX.GetPlayerFromId(player)
    if not xPlayer then
        return false
    end

    if not meta then
        if GetPlayerItemCount(player, item) < amount then
            return false
        end
        xPlayer.removeInventoryItem(item, amount)
        return true
    end

    local inventory = xPlayer.getInventory()
    local slots = {}
    local total = 0

    for i, itemData in ipairs(inventory) do
        if itemData.name == item then
            local match = true
            local itemMeta = itemData.metadata or itemData.meta or {}
            for k, v in pairs(meta) do
                if itemMeta[k] ~= v then
                    match = false
                    break
                end
            end
            if match then
                table.insert(slots, { index = i, data = itemData })
                total = total + (itemData.count or itemData.amount or 1)
            end
        end
    end

    if total < amount then return false end

    local metadata = {}
    local remaining = amount

    for _, slotInfo in ipairs(slots) do
        if remaining <= 0 then break end
        local itemData = slotInfo.data
        local remove = math.min(itemData.count or itemData.amount or 1, remaining)

        xPlayer.removeInventoryItem(item, remove, itemData.metadata or itemData.meta)
        for i = 1, remove do
            table.insert(metadata, itemData.metadata or itemData.meta or {})
        end
        remaining = remaining - remove
    end

    return remaining == 0, metadata
end

function SetItemDurability(player, slot, durability)
    -- Not available for this inventory
    return nil
end

function GetItemBySlot(player, slot)
    -- Not available for this inventory
    return nil
end

function OpenCustomStash(player, stashId, label, slots, weight)
    xPlayer = ESX.GetPlayerFromId(player)
    TriggerClientEvent('inventory:openHouse', xPlayer.source, xPlayer.identifier, stashId, label, weight)
    
    return true
end

function GetStashItems(stashId)
    -- not possible with this system
    return {}
end

function AddPlayerWeapon(player, weapon, ammo)
    local xPlayer = ESX.GetPlayerFromId(player)
    if not xPlayer then
        return false
    end

    xPlayer.addWeapon(weapon, ammo or 0)
    return true
end

function DoesPlayerHaveWeapon(player, weapon)
    local xPlayer = ESX.GetPlayerFromId(player)
    if not xPlayer then
        return false
    end

    return xPlayer.hasWeapon(weapon)
end

function RemovePlayerWeapon(player, weapon)
    local xPlayer = ESX.GetPlayerFromId(player)
    if not xPlayer then
        return false
    end

    xPlayer.removeWeapon(weapon)
    return true
end

function GetInventoryItems()
    if not ESX or type(ESX.GetItems) ~= 'function' then
        return {}
    end
    local raw = ESX.GetItems()
    return NormalizeItems(raw)
end
--
