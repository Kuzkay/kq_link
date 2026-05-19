if Link.framework ~= 'qbox' and Link.framework ~= 'qbx' and Link.framework ~= 'qbx-core' then
    return
end

require '@qbx_core.modules.playerdata'

PLAYER_DATA = QBX.PlayerData

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PLAYER_DATA = QBX.PlayerData
    TriggerEvent('kq_link:jobUpdated', PLAYER_DATA.job.name)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(jobData)
    PLAYER_DATA.job = jobData
    TriggerEvent('kq_link:jobUpdated', PLAYER_DATA.job.name)
end)

-- Already defined in `links/frameworks/qbcore/client.lua`
-- AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
--    TriggerEvent('kq_link:playerLoaded')
-- end)

function GetPlayerJob()
    if not PLAYER_DATA or not PLAYER_DATA.job then
        return nil
    end
    
    return PLAYER_DATA.job.name
end

function NotifyViaFramework(message, type)
    exports.qbx_core:Notify(message, type, 4000)
end
