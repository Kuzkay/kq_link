if Link.vehiclekeys ~= 'wasabi_carlock' then return end

function GiveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    return exports['wasabi_carlock']:GiveKey(player, plate)
end

function RemoveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    return exports['wasabi_carlock']:RemoveKey(player, plate)
end
