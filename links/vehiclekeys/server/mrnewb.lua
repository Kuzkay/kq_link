if Link.vehiclekeys ~= 'mrnewb' then return end

local function strTrim(str)
    return string.gsub(str, '^%s*(.-)%s*$', '%1')
end

function GiveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    exports.MrNewbVehicleKeys:GiveKeysByPlate(player, strTrim(plate))
    return true
end

function RemoveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    exports.MrNewbVehicleKeys:RemoveKeysByPlate(player, strTrim(plate))
    return true
end
