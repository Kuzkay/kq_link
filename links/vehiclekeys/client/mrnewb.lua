if Link.vehiclekeys ~= 'mrnewb' then return end

-- Handle server-triggered key operations
RegisterNetEvent('kq_link:vehiclekeys:mrnewb:give')
AddEventHandler('kq_link:vehiclekeys:mrnewb:give', function(plate)
    exports['MrNewbVehicleKeys']:GiveKeysByPlate(plate)
end)

RegisterNetEvent('kq_link:vehiclekeys:mrnewb:remove')
AddEventHandler('kq_link:vehiclekeys:mrnewb:remove', function(plate)
    exports['MrNewbVehicleKeys']:RemoveKeysByPlate(plate)
end)
