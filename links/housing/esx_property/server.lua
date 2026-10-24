local insideProperty = {}

RegisterNetEvent('esx_property:enter')
AddEventHandler('esx_property:enter', function(propertyId)
    local src = source
    insideProperty[src] = tonumber(propertyId)
    TriggerClientEvent('kq_link:client:housing:esx:setCurrent', src, insideProperty[src])
end)

RegisterNetEvent('esx_property:leave')
AddEventHandler('esx_property:leave', function()
    local src = source
    insideProperty[src] = nil
    TriggerClientEvent('kq_link:client:housing:esx:setCurrent', src, nil)
end)

AddEventHandler('playerDropped', function()
    insideProperty[source] = nil
end)

Housing.Register('esx_property', {
    IsPropertyOwner = function(source, propertyId)
        if GetResourceState('esx_property') ~= 'started' then
            return false
        end

        propertyId = tonumber(propertyId)

        local properties = exports.esx_property:GetProperties()
        local property = properties and properties[propertyId]
        if not property then
            return false
        end

        local identifier = GetPlayerCharacterId(source)
        if not identifier then
            return false
        end

        if property.Owned and property.Owner == identifier then
            return true
        end

        return exports.esx_property:DoesPlayerHaveKeys(propertyId, identifier) == true -- returns {} when no keys
    end,
})
