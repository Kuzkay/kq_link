local currentProperty = nil

RegisterNetEvent('kq_link:client:housing:esx:setCurrent')
AddEventHandler('kq_link:client:housing:esx:setCurrent', function(propertyId)
    currentProperty = propertyId
end)

Housing.Register('esx_property', {
    GetCurrentProperty = function()
        return currentProperty
    end,
})
