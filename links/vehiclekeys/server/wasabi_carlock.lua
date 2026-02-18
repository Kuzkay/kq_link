if Link.vehiclekeys ~= 'wasabi_carlock' then return end

local function strTrim(str)
    return string.gsub(str, '^%s*(.-)%s*$', '%1')
end

function GiveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    return exports['wasabi_carlock']:GiveKey(player, strTrim(plate))
end

function RemoveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    return exports['wasabi_carlock']:RemoveKey(player, strTrim(plate))
end
