if Link.framework ~= 'qb-core' and Link.framework ~= 'qbcore' then
    return
end

QBX = exports['qbx_core']:GetCoreObject()

if QBX.Functions.GetPlayerData() and QBX.Functions.GetPlayerData().job then
    PLAYER_DATA = QBX.PlayerData
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PLAYER_DATA = QBX.PlayerData
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(jobData)
    PLAYER_DATA.job = jobData
end)
