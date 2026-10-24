Housing.Register('qb-houses', {
    IsPropertyOwner = function(source, propertyId)
        if GetResourceState('qb-houses') ~= 'started' then
            return false
        end

        local QBCore = exports['qb-core']:GetCoreObject()
        local player = QBCore.Functions.GetPlayer(source)
        if not player then
            return false
        end

        return exports['qb-houses']:hasKey(player.PlayerData.license, player.PlayerData.citizenid, tostring(propertyId)) == true
    end,
})
