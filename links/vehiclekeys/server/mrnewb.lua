if Link.vehiclekeys ~= 'mrnewb' then return end

local function strTrim(str)
    return string.gsub(str, '^%s*(.-)%s*$', '%1')
end

function GiveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerClientEvent('kq_link:vehiclekeys:mrnewb:give', player, strTrim(plate))
    return true
end

function RemoveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerClientEvent('kq_link:vehiclekeys:mrnewb:remove', player, strTrim(plate))
    return true
end
