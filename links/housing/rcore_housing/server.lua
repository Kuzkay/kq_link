Housing.Register('rcore_housing', {
    IsPropertyOwner = function(source, propertyId)
        if GetResourceState('rcore_housing') ~= 'started' then
            return false
        end

        return exports.rcore_housing:HasKeys(source, tonumber(propertyId)) == true
    end,
})
