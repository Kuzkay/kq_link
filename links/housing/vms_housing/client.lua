Housing.Register('vms_housing', {
    GetCurrentProperty = function()
        local propertyId = exports.vms_housing:IsPlayerInsideProperty()
        return propertyId
    end,
})
