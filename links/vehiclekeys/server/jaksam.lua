if Link.vehiclekeys ~= 'jaksam' then return end

local function strTrim(str)
    return string.gsub(str, '^%s*(.-)%s*$', '%1')
end

function GiveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerClientEvent('vehicles_keys:selfGiveVehicleKeys', player, strTrim(plate))
    return true
end

function RemoveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerClientEvent('vehicles_keys:selfRemoveVehicleKeys', player, strTrim(plate))
    return true
end
