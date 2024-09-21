if Link.framework ~= 'qbox' and Link.framework ~= 'qbx' and Link.framework ~= 'qbx-core' then
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

function GetPlayerJob()
    return PLAYER_DATA.job.name
end

function NotifyViaFramework(message, type)
    exports.qbx_core:Notify(message, type, 4000)
end
