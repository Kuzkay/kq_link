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
