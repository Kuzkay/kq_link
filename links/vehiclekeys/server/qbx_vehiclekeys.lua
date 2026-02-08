if Link.vehiclekeys ~= 'qbx_vehiclekeys' then return end

function GiveVehicleKeys(player, vehicle)
    exports['qbx_vehiclekeys']:GiveKeys(player, vehicle, true)
    return true
end

function RemoveVehicleKeys(player, vehicle)
    exports['qbx_vehiclekeys']:RemoveKeys(player, vehicle, true)
    return true
end
