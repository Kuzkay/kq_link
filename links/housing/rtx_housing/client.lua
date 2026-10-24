Housing.Register('rtx_housing', {
    GetCurrentProperty = function()
        local inside, propertyId = exports.rtx_housing:IsPlayerInsideProperty()
        if not inside then
            return nil
        end

        return propertyId
    end,
})
