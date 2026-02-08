if Link.vehiclekeys ~= 'renewed' then return end

function GiveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    exports['Renewed-Vehiclekeys']:addKey(player, plate)
    return true
end

function RemoveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    exports['Renewed-Vehiclekeys']:removeKey(player, plate)
    return true
end
