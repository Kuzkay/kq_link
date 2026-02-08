if Link.vehiclekeys ~= 'qb-vehiclekeys' then return end

function GiveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerClientEvent('qb-vehiclekeys:client:AddKeys', player, plate)
    return true
end

function RemoveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerClientEvent('qb-vehiclekeys:client:RemoveKeys', player, plate)
    return true
end
