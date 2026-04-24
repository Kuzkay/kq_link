if Link.vehiclekeys ~= 'cd_garage' then return end

local function strTrim(str)
    return string.gsub(str, '^%s*(.-)%s*$', '%1')
end

function GiveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerClientEvent('cd_garage:AddKeys', player, strTrim(plate))
    return true
end

function RemoveVehicleKeys(player, vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerClientEvent('cd_garage:RemoveKeys', player, strTrim(plate))
    return true
end
