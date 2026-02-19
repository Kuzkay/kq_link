if Link.vehiclekeys ~= 'jaksam' then return end

local function strTrim(str)
    return string.gsub(str, '^%s*(.-)%s*$', '%1')
end

function GiveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    exports["vehicles_keys"]:giveVehicleKeysToPlayerId(player, strTrim(plate), 'temporary')
    return true
end

function RemoveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    exports["vehicles_keys"]:removeKeysFromPlayerId(player, strTrim(plate))
    return true
end
