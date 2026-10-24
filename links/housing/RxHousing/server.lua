local insideProperty = {}

RegisterNetEvent('rxhousing:onPropertyEntered')
AddEventHandler('rxhousing:onPropertyEntered', function(src, property)
    local propertyId = type(property) == 'table' and (property.id or property.propertyId) or property
    insideProperty[src] = tonumber(propertyId) or propertyId
    TriggerClientEvent('kq_link:client:housing:rx:setCurrent', src, insideProperty[src])
end)

RegisterNetEvent('rxhousing:onPropertyExited')
AddEventHandler('rxhousing:onPropertyExited', function(src)
    insideProperty[src] = nil
    TriggerClientEvent('kq_link:client:housing:rx:setCurrent', src, nil)
end)

AddEventHandler('playerDropped', function()
    insideProperty[source] = nil
end)

Housing.Register('RxHousing', {
    IsPropertyOwner = function(source, propertyId)
        if GetResourceState('RxHousing') ~= 'started' then
            return false
        end

        propertyId = tonumber(propertyId) or propertyId

        local identifier = GetPlayerCharacterId(source)
        if not identifier then
            return false
        end

        local property = exports['RxHousing']:GetProperty(propertyId)
        if property and property.owner == identifier then
            return true
        end

        return exports['RxHousing']:HasKey(propertyId, identifier) == true
    end,
})
