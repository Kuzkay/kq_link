if Link.vehiclekeys ~= 'renewed' then return end

local function strTrim(str)
    return string.gsub(str, '^%s*(.-)%s*$', '%1')
end

function GiveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    exports['Renewed-Vehiclekeys']:addKey(player, strTrim(plate))
    return true
end

function RemoveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    exports['Renewed-Vehiclekeys']:removeKey(player, strTrim(plate))
    return true
end
