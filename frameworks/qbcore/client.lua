if Link.framework ~= 'qb-core' and Link.framework ~= 'qbcore' then
    return
end

QBCore = exports['qb-core']:GetCoreObject()

if QBCore.Functions.GetPlayerData() and QBCore.Functions.GetPlayerData().job then
    PLAYER_DATA = QBCore.Functions.GetPlayerData()
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PLAYER_DATA = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(jobData)
    PLAYER_DATA.job = jobData
end)

function GetPlayerJob()
    return PLAYER_DATA.job.name
end

function NotifyViaFramework(message, type)
    QBCore.Functions.Notify(message, type, 4000)
end
