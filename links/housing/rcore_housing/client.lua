Housing.Register('rcore_housing', {
    GetCurrentProperty = function()
        local propertyId = exports.rcore_housing:IsPlayerInsideProperty()
        return propertyId
    end,
})
