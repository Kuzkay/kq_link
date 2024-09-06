if Link.framework ~= 'qb-core' and Link.framework ~= 'qbcore' then
    return
end

require '@qbx_core.modules.playerdata'

PLAYER_DATA = QBX.PlayerData

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PLAYER_DATA = QBX.PlayerData
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(jobData)
    PLAYER_DATA.job = jobData
end)

function NotifyViaFramework(message, type)
    exports.qbx_core:Notify(message, type, 4000)
end
