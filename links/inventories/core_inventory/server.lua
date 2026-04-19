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

function GetInventoryItems()
    return UseCache('kq_link:core_inventory:items', function()
        local raw
        local ok = pcall(function() raw = exports.core_inventory:getItemsList() end)
        if not ok or type(raw) ~= 'table' then return {} end

        local items = {}
        for name, def in pairs(raw) do
            local key = def.name or name
            items[key] = NormalizeItemDefinition(key, def)
        end
        return items
    end, 60000)
end

function GetInventoryImagePath()
    return 'nui://core_inventory/html/img/items/'
end
--
