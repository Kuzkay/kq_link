Housing.Register('loaf_housing', {
    IsPropertyOwner = function(source, propertyId)
        if GetResourceState('loaf_housing') ~= 'started' then
            return false
        end

        local id, uniqueId = tostring(propertyId):match('^(%d+)_(.+)$')
        if not id then
            return false
        end

        return exports.loaf_keysystem:HasKey(source, ('housing_key_%s_%s'):format(id, uniqueId)) == true
    end,
})
