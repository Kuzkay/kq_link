Housing.Register('origen_housing', {
    GetCurrentProperty = function()
        local houseId = exports.origen_housing:insideHouse()
        if type(houseId) == 'number' or type(houseId) == 'string' then
            return houseId
        end

        return nil
    end,
})
