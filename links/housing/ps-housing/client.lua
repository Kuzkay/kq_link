local currentProperty = nil

RegisterNetEvent('ps-housing:client:enterProperty')
AddEventHandler('ps-housing:client:enterProperty', function(propertyId)
    currentProperty = tostring(propertyId)
end)

Housing.Register('ps-housing', {
    GetCurrentProperty = function()
        if not currentProperty then
            return nil
        end

        local property = exports['ps-housing']:GetProperty(currentProperty)
        if not property or not property.inProperty then
            currentProperty = nil
            return nil
        end

        return currentProperty
    end,
})
