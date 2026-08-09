if Link.inventory ~= 'jaksam_inventory' and Link.inventory ~= 'jaksam' then
    return
end

function GetPlayerInventory(player)
    return NormalizeInventoryOutput(exports['jaksam_inventory']:getInventory(player))
end

function GetPlayerItemData(player, item, meta)
    local data, slotId = exports['jaksam_inventory']:getItemByName(player, item, meta)
    return data
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
    amount = amount or 1

    local inventory = exports['jaksam_inventory']:getInventory(player)
    if not inventory or not inventory.items then
        local success = exports['jaksam_inventory']:removeItem(player, item, amount, meta)
        return success
    end

    local slots = {}
    local total = 0

    for slot, itemData in pairs(inventory.items) do
        if itemData.name == item then
            local match = true
            if meta then
                local itemMeta = itemData.metadata or {}
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

        local success = exports['jaksam_inventory']:removeItem(player, item, remove, itemData.metadata)
        if success then
            for i = 1, remove do
                table.insert(metadata, itemData.metadata or {})
            end
            remaining = remaining - remove
        end
    end

    return remaining == 0, metadata
end

function AddPlayerWeapon(player, weapon, ammo)
    return AddPlayerItem(player, string.upper(weapon), 1, { ammo = ammo or 0 })
end

function DoesPlayerHaveWeapon(player, weapon)
    return GetPlayerItemCount(player, string.upper(weapon)) > 0
end

function RemovePlayerWeapon(player, weapon)
    return RemovePlayerItem(player, string.upper(weapon), 1)
end

function SetItemDurability(player, slot, durability)
    local success, response = exports['jaksam_inventory']:setDurability(player, slot, durability)
    return success
end

function GetItemBySlot(player, slot)
    return exports['jaksam_inventory']:getItemFromSlot(player, slot)
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
--
