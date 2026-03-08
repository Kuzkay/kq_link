-- LINKS
exports('RegisterUsableItem', RegisterUsableItem)

exports('GetPlayerJob', GetPlayerJob)
exports('GetPlayersWithJob', GetPlayersWithJob)

exports('CanPlayerAfford', CanPlayerAfford)
exports('AddPlayerMoney', AddPlayerMoney)
exports('RemovePlayerMoney', RemovePlayerMoney)
exports('GetPlayerMoney', GetPlayerMoney)

exports('GetPlayerItemData', GetPlayerItemData)
exports('GetPlayerItemCount', GetPlayerItemCount)
exports('AddPlayerItem', AddPlayerItem)

exports('AddPlayerWeapon', AddPlayerWeapon)
exports('RemovePlayerWeapon', RemovePlayerWeapon)
exports('DoesPlayerHaveWeapon', DoesPlayerHaveWeapon)

exports('RemovePlayerItem', RemovePlayerItem)
exports('GetPlayerCharacterId', GetPlayerCharacterId)
exports('GetPlayerCharacterName', GetPlayerCharacterName)
exports('GetSourceFromCharacterId', GetSourceFromCharacterId)

exports('OpenCustomStash', OpenCustomStash)
exports('GetStashItems', GetStashItems)

exports('GiveVehicleKeys', GiveVehicleKeys)
exports('RemoveVehicleKeys', RemoveVehicleKeys)

exports('GetPlayerInventory', GetPlayerInventory)

-- Slot-level inventory API (when link supports it, e.g. ox_inventory)
exports('GetItemSlots', function(player, itemName)
    if GetItemSlots then return GetItemSlots(player, itemName) end
    return nil, 0
end)
exports('GetSlot', function(player, slotId)
    if GetSlot then return GetSlot(player, slotId) end
    return nil
end)
exports('SetMetadata', function(player, slotId, metadata)
    if SetMetadata then return SetMetadata(player, slotId, metadata) end
    return nil
end)
exports('GetInventoryItems', function(player)
    if GetInventoryItems then return GetInventoryItems(player) end
    return {}
end)
exports('RegisterCreateItemHook', function(itemName, callback, options)
    if RegisterCreateItemHook then return RegisterCreateItemHook(itemName, callback, options) end
end)

-- RESOURCE
exports('AddPlayerItemToFit', AddPlayerItemToFit)
exports('RegisterServerCallback', RegisterServerCallback)

