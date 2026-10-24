Housing.Register('vms_housing', {
    IsPropertyOwner = function(source, propertyId)
        if GetResourceState('vms_housing') ~= 'started' then
            return false
        end

        local identifier = GetPlayerCharacterId(source)
        if not identifier then
            return false
        end

        local property = exports.vms_housing:GetProperty(propertyId)
        if property and property.owner == identifier then
            return true
        end

        return exports.vms_housing:HasKeys(source, identifier, propertyId) == true
    end,
})
