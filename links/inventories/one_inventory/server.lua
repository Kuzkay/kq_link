if Link.inventory ~= 'one_inventory' and Link.inventory ~= 'one' then
    return
end

function GetPlayerInventory(player)
    return NormalizeInventoryOutput(exports.one_inventory:GetInventoryItems(player) or {})
end

function GetPlayerItemData(player, item, meta)
    return exports.one_inventory:GetItem(player, item, meta)
end

function GetPlayerItemCount(player, item, meta)
    return exports.one_inventory:GetItemCount(player, item, meta) or 0
end

function AddPlayerItem(player, item, amount, meta)
    amount = amount or 1

    if not exports.one_inventory:CanCarryItem(player, item, amount) then
        return false
    end

    return exports.one_inventory:AddItem(player, item, amount, meta)
end

function SetItemDurability(player, slot, durability)
    return exports.one_inventory:SetItemDurability(player, slot, durability)
end

function GetItemBySlot(player, slot)
    return exports.one_inventory:GetSlot(player, slot)
end

function RemovePlayerItem(player, item, amount, meta)
    amount = amount or 1

    local items = exports.one_inventory:SearchInventory(player, item, meta)
    if not items or #items == 0 then
        return false
    end

    local total = 0
    for _, itemData in ipairs(items) do
        total = total + (itemData.count or 1)
    end

    if total < amount then
        return false
    end

    local metadata = {}
    local remaining = amount

    for _, itemData in ipairs(items) do
        if remaining <= 0 then
            break
        end

        local remove = math.min(itemData.count or 1, remaining)
        if exports.one_inventory:RemoveItem(player, item, remove, itemData.metadata, itemData.slot) then
            for i = 1, remove do
                table.insert(metadata, itemData.metadata or {})
            end
            remaining = remaining - remove
        end
    end

    return remaining == 0, metadata
end

-- Stashes
function OpenCustomStash(player, stashId, label, slots, weight)
    exports.one_inventory:OpenInventory(player, 'stash', {
        id = stashId,
        label = label,
        slots = slots,
        maxWeight = weight,
    })
end

function GetStashItems(stashId)
    return exports.one_inventory:GetInventoryItems('stash:' .. stashId)
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
