Housing.Register('origen_housing', {
    IsPropertyOwner = function(source, propertyId)
        if GetResourceState('origen_housing') ~= 'started' then
            return false
        end

        propertyId = tonumber(propertyId)
        if not propertyId then
            return false
        end

        local identifier = GetPlayerCharacterId(source)
        if not identifier then
            return false
        end

        if exports.origen_housing:hasKey(nil, identifier, propertyId) == true then
            return true
        end

        local house = exports.origen_housing:getHouse(propertyId)
        if type(house) == 'table' and (house.owner == identifier or house.citizenid == identifier) then
            return true
        end

        return false
    end,
})
