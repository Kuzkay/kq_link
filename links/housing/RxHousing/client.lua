local currentProperty = nil

RegisterNetEvent('kq_link:client:housing:rx:setCurrent')
AddEventHandler('kq_link:client:housing:rx:setCurrent', function(propertyId)
    currentProperty = propertyId
end)

Housing.Register('RxHousing', {
    GetCurrentProperty = function()
        return currentProperty
    end,
})
