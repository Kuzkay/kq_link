if Link.vehiclekeys ~= 'mrnewb' then return end

function GiveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerClientEvent('kq_link:vehiclekeys:mrnewb:give', player, plate)
    return true
end

function RemoveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerClientEvent('kq_link:vehiclekeys:mrnewb:remove', player, plate)
    return true
end
