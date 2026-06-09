if Link.inventory ~= 'origen_inventory' and Link.inventory ~= 'origen' then
    return
end

function GetPlayerInventory(player)
    local inventory = exports['origen_inventory']:getInventory(player)
    
    if not inventory then
        return {}
    end
    
    return NormalizeInventoryOutput(inventory.inventory)
end

function RegisterUsableItem(...)
    -- Inventory does not have a native method for registering usable items
    return
end

function GetPlayerItemData(player, item, meta)
    return exports['origen_inventory']:GetItem(player, item, meta)
end

function GetPlayerItemCount(player, item, meta)
    if not meta then
        local data = exports['origen_inventory']:GetItem(player, item)
        return data and (data.count or data.amount or 0) or 0
    end

    local inventory = exports['origen_inventory']:getInventory(player)
    if not inventory then
        return 0
    end

    local count = 0
    for _, itemData in pairs(inventory.inventory) do
        if itemData.name == item then
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
    return count
end

function AddPlayerItem(player, item, amount, meta)
    local success, response = exports['origen_inventory']:AddItem(player, item, amount or 1, meta)
    return success
end

function RemovePlayerItem(player, item, amount, meta)
    amount = amount or 1

    local inventory = exports['origen_inventory']:getInventory(player)
    if not inventory then
        return false
    end

    local slots = {}
    local total = 0

    for slot, itemData in pairs(inventory.inventory) do
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
                table.insert(slots, { slot = itemData.slot or slot, data = itemData })
                total = total + (itemData.count or itemData.amount or 1)
            end
        end
    end

    if total < amount then 
        return false
    end

    local metadata = {}
    local remaining = amount

    for _, slotInfo in ipairs(slots) do
        if remaining <= 0 then break end
        local itemData = slotInfo.data
        local remove = math.min(itemData.count or itemData.amount or 1, remaining)

        local success = exports['origen_inventory']:removeItem(player, item, remove, slotInfo.slot)
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
    local success, response = exports['origen_inventory']:setMetadata(player, slot, { durability = durability })
    return success
end

function GetItemBySlot(player, slot)
    return exports['origen_inventory']:getSlot(player, slot)
end

-- Stashes
local stashes = {}
function OpenCustomStash(player, stashId, label, slots, weight)
    if not stashes[stashId] then
        exports['origen_inventory']:RegisterStash(stashId, {
            label = label,
            slots = slots or 50,
            weight = weight or 100000
        })

        stashes[stashId] = true
    end

    exports['origen_inventory']:OpenInventory(player, 'stash', stashId)
end

function GetStashItems(stashId)
    if not stashes[stashId] then
        return {}
    end

    return exports['origen_inventory']:GetStashItems(stashId)
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
    return UseCache('kq_link:origen_inventory:items', function()
        return NormalizeItems(exports['origen_inventory']:getItems())
    end, 60000)
end
--
