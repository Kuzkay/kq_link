if Link.inventory ~= 'ps-inventory' and Link.inventory ~= 'ps' then
    return
end

function GetPlayerInventory(player)
    return NormalizeInventoryOutput(exports['ps-inventory']:GetInventory(player))
end

function GetPlayerItemData(player, item)
    local data = exports['ps-inventory']:GetItemByName(player, item)
    return data
end

function GetPlayerItemCount(player, item)
  local itemData = GetPlayerItemData(player, item)
  if not itemData then
    return 0
  end 

  return itemData.amount or 0
end

function AddPlayerItem(player, item, amount, meta)
    return exports['ps-inventory']:AddItem(player, item, amount, nil, meta)
end

function RemovePlayerItem(player, item, amount)
    return exports['ps-inventory']:RemoveItem(player, item, amount, nil)
end

-- Stashes
function OpenCustomStash(player, stashId, label, slots, weight)
    stashId = ('stash_' .. stashId):gsub('-', '_')
    
    local data = { label = label, maxweight = weight, slots = slots }
    exports['ps-inventory']:OpenInventory(player, stashId, data)
end

function GetStashItems(stashId)
    stashId = ('stash_' .. stashId):gsub('-', '_')

    exports['ps-inventory']:GetStashItems(stashId)
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
    return UseCache('kq_link:ps-inventory:items', function()
        if not QBCore or not QBCore.Shared or type(QBCore.Shared.Items) ~= 'table' then
            return {}
        end

        local items = {}
        for name, def in pairs(QBCore.Shared.Items) do
            items[name] = NormalizeItemDefinition(name, def)
        end
        return items
    end, 60000)
end

function GetInventoryImagePath()
    return 'nui://ps-inventory/html/images/'
end
--
