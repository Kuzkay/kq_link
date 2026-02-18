if Link.vehiclekeys ~= 'qb-vehiclekeys' then return end

local function strTrim(str)
    return string.gsub(str, '^%s*(.-)%s*$', '%1')
end

function GiveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerClientEvent('qb-vehiclekeys:client:AddKeys', player, strTrim(plate))
    return true
end

function RemoveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerClientEvent('qb-vehiclekeys:client:RemoveKeys', player, strTrim(plate))
    return true
end
