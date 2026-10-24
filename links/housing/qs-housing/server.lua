local function playerOwnsHouse(source, propertyId)
    local ok, houses = pcall(function()
        return exports['qs-housing']:GetPlayerHouses(source)
    end)

    if not ok or type(houses) ~= 'table' then
        return false
    end

    for _, house in pairs(houses) do
        local houseId = type(house) == 'table' and (house.house or house.name or house.id) or house
        if tostring(houseId) == propertyId then
            return true
        end
    end

    return false
end

local function playerHasKey(source, propertyId)
    if GetResourceState('qb-core') ~= 'started' then
        return false
    end

    local player = exports['qb-core']:GetCoreObject().Functions.GetPlayer(source)
    if not player then
        return false
    end

    local license = player.PlayerData.license
    local citizenid = player.PlayerData.citizenid

    local ok, hasKey = pcall(function()
        return exports['qs-housing']:CheckHasKey(license, citizenid, propertyId, source)
    end)

    if ok and hasKey == true then
        return true
    end

    ok, hasKey = pcall(function()
        return exports['qs-housing']:hasKey(license, citizenid, propertyId)
    end)

    return ok and hasKey == true
end

Housing.Register('qs-housing', {
    IsPropertyOwner = function(source, propertyId)
        if GetResourceState('qs-housing') ~= 'started' then
            return false
        end

        propertyId = tostring(propertyId)

        return playerOwnsHouse(source, propertyId) or playerHasKey(source, propertyId)
    end,
})
