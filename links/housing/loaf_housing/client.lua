Housing.Register('loaf_housing', {
    GetCurrentProperty = function()
        local ok, current = pcall(function()
            return exports.loaf_housing:CurrentHouse()
        end)

        if not ok or current == nil or current == false then
            return nil
        end

        if type(current) == 'table' then
            local id = current.id or current.house
            if id and current.uniqueId then
                return ('%s_%s'):format(id, current.uniqueId)
            end

            return nil
        end

        local okOwned, owned = pcall(function()
            return exports.loaf_housing:GetOwnedHouses()
        end)

        if not okOwned or type(owned) ~= 'table' then
            return nil
        end

        for _, house in pairs(owned) do
            if house and house.uniqueId and tostring(house.id) == tostring(current) then
                return ('%s_%s'):format(house.id, house.uniqueId)
            end
        end

        return nil
    end,
})
