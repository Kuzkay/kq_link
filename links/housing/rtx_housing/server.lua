Housing.Register('rtx_housing', {
    IsPropertyOwner = function(source, propertyId)
        if GetResourceState('rtx_housing') ~= 'started' then
            return false
        end

        propertyId = tonumber(propertyId) or propertyId

        local ok, hasPerms = pcall(function()
            return exports.rtx_housing:HasPlayerAnyPropertyPermissions(source, propertyId)
        end)

        if ok and hasPerms == true then
            return true
        end

        local okKeys, hasKeys = pcall(function()
            return exports.rtx_housing:CheckPropertyKeys(source, propertyId)
        end)

        return okKeys and hasKeys == true
    end,
})
