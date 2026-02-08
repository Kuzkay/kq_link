if Link.vehiclekeys ~= 'jaksam' then return end

function GiveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerClientEvent('vehicles_keys:selfGiveVehicleKeys', player, plate)
    return true
end

function RemoveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerClientEvent('vehicles_keys:selfRemoveVehicleKeys', player, plate)
    return true
end
