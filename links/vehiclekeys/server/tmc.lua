if Link.vehiclekeys ~= 'tmc' then return end

local TMC = exports.core:getCoreObject()

function GiveVehicleKeys(player, vehicle)
    local veh = Entity(vehicle)
    TriggerClientEvent('vehiclelock:client:addKeys', player, veh)
    TMC.Functions.TriggerEvent("TMC:SetEntityStateBag", NetworkGetNetworkIdFromEntity(veh), "fuel", 100.0)
    return true
end

function RemoveVehicleKeys(player, vehicle)
    return true
end
