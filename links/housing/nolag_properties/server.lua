Housing.Register('nolag_properties', {
    IsPropertyOwner = function(source, propertyId)
        if GetResourceState('nolag_properties') ~= 'started' then
            return false
        end

        propertyId = tonumber(propertyId) or propertyId

        local data = exports.nolag_properties:GetPropertyData(propertyId)
        if not data then
            return false
        end

        local identifier = GetPlayerCharacterId(source)
        if not identifier then
            return false
        end

        if data.owner == identifier or data.renter == identifier then
            return true
        end

        return exports.nolag_properties:HasKey(identifier, propertyId) == true
    end,
})
