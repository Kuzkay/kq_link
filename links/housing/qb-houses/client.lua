Housing.Register('qb-houses', {
    GetCurrentProperty = function()
        if GetResourceState('qb-core') ~= 'started' then
            return nil
        end

        local QBCore = exports['qb-core']:GetCoreObject()
        local playerData = QBCore.Functions.GetPlayerData()
        local inside = playerData and playerData.metadata and playerData.metadata.inside

        return inside and inside.house or nil
    end,
})
