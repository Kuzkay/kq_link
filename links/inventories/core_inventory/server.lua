if Link.inventory ~= 'core_inventory' and Link.inventory ~= 'core' then
    return
end

function GetPlayerInventory(player)
    return NormalizeInventoryOutput(exports['core_inventory']:getInventory(player))
end

function GetPlayerItemData(player, item, meta)
    local inventory = exports['core_inventory']:getInventory(player)
    if not inventory or not inventory.items then
        return nil
    end

    for slot, itemData in pairs(inventory.items) do
        if itemData.name == item then
            if not meta then
                return itemData
            end
            local match = true
            local itemMeta = itemData.metadata or itemData.info or {}
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
    local inventory = exports['core_inventory']:getInventory(player)
    if not inventory or not inventory.items then
        return 0
    end

    local count = 0
    for _, itemData in pairs(inventory.items) do
        if itemData.name == item then
            if not meta then
                count = count + (itemData.count or itemData.amount or 1)
            else
                local match = true
                local itemMeta = itemData.metadata or itemData.info or {}
                for k, v in pairs(meta) do
                    if itemMeta[k] ~= v then
                        match = false
                        break
                    end
                end
                if match then count = count + (itemData.count or itemData.amount or 1) end
            end
        end
    end
    return count
end

function AddPlayerItem(player, item, amount, meta)
    return exports['core_inventory']:addItem(player, item, amount or 1, meta)
end

function RemovePlayerItem(player, item, amount, meta)
    amount = amount or 1

    local inventory = exports['core_inventory']:getInventory(player)
    if not inventory or not inventory.items then
        return false
    end

    local slots = {}
    local total = 0

    for slot, itemData in pairs(inventory.items) do
        if itemData.name == item then
            local match = true
            if meta then
                local itemMeta = itemData.metadata or itemData.info or {}
                for k, v in pairs(meta) do
                    if itemMeta[k] ~= v then
                        match = false
                        break
                    end
                end
            end
            if match then
                table.insert(slots, { slot = slot, data = itemData })
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

        local success = exports['core_inventory']:removeItem(player, item, remove, slotInfo.slot)
        if success then
            for i = 1, remove do
                table.insert(metadata, itemData.metadata or itemData.info or {})
            end
            remaining = remaining - remove
        end
    end

    return remaining == 0, metadata
end

function SetItemDurability(player, slot, durability)
    return exports['core_inventory']:setDurability(player, slot, durability)
end

function GetItemBySlot(player, slot)
    return exports['core_inventory']:getItemBySlot(player, slot)
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

function GetInventoryItems()
    return UseCache('kq_link:core_inventory:items', function()
        return NormalizeItems(exports.core_inventory:getItemsList())
    end, 60000)
end
--
