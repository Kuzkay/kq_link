-- LINKS
exports('RegisterUsableItem', RegisterUsableItem)

exports('GetPlayerJob', GetPlayerJob)
exports('GetPlayersWithJob', GetPlayersWithJob)

exports('CanPlayerAfford', CanPlayerAfford)
exports('AddPlayerMoney', AddPlayerMoney)
exports('RemovePlayerMoney', RemovePlayerMoney)

exports('GetPlayerItemData', GetPlayerItemData)
exports('GetPlayerItemCount', GetPlayerItemCount)
exports('AddPlayerItem', AddPlayerItem)

exports('AddPlayerWeapon', AddPlayerWeapon)
exports('RemovePlayerWeapon', RemovePlayerWeapon)
exports('DoesPlayerHaveWeapon', DoesPlayerHaveWeapon)

exports('RemovePlayerItem', RemovePlayerItem)
exports('GetPlayerCharacterId', GetPlayerCharacterId)
exports('GetPlayerCharacterName', GetPlayerCharacterName)

exports('OpenCustomStash', OpenCustomStash)
exports('GetStashItems', GetStashItems)

exports('GiveVehicleKeys', GiveVehicleKeys)
exports('RemoveVehicleKeys', RemoveVehicleKeys)

exports('GetPlayerInventory', GetPlayerInventory)

RegisterServerCallback('kq_link:getInventoryItems', function(source, cb)
    if type(GetInventoryItems) ~= 'function' then
        return cb({})
    end
    cb(GetInventoryItems())
end)

-- RESOURCE
exports('AddPlayerItemToFit', AddPlayerItemToFit)
exports('RegisterServerCallback', RegisterServerCallback)

