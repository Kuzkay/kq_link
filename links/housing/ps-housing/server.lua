Housing.Register('ps-housing', {
    IsPropertyOwner = function(source, propertyId)
        if GetResourceState('ps-housing') ~= 'started' then
            return false
        end

        return exports['ps-housing']:IsOwner(source, tostring(propertyId)) == true -- also true for key holders
    end,
})
