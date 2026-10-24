Housing.Register('qs-housing', {
    GetCurrentProperty = function()
        local ok, houseId = pcall(function()
            return exports['qs-housing']:getEnteredHouse()
        end)

        if ok and houseId then
            return houseId
        end

        return nil
    end,
})
