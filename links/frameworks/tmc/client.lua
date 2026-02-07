if Link.framework ~= 'tmc' then
    return
end

TMC = exports.core:getCoreObject()

if TMC.Functions.GetPlayerData() and TMC.Functions.GetPlayerData().job then
    PLAYER_DATA = TMC.Functions.GetPlayerData()
end

RegisterNetEvent('TMC:Client:OnPlayerLoaded')
AddEventHandler('TMC:Client:OnPlayerLoaded', function()
    PLAYER_DATA = TMC.Functions.GetPlayerData()
    TriggerEvent('kq_link:jobUpdated', PLAYER_DATA.job.name)
end)

RegisterNetEvent('TMC:Client:OnJobUpdate')
AddEventHandler('TMC:Client:OnJobUpdate', function(jobData)
    PLAYER_DATA.job = jobData
    TriggerEvent('kq_link:jobUpdated', PLAYER_DATA.job and PLAYER_DATA.job[1] and PLAYER_DATA.job[1].name)
end)

function GetPlayerJob()
    return PLAYER_DATA.job and PLAYER_DATA.job[1] and PLAYER_DATA.job[1].name
end

function NotifyViaFramework(message, type)
    TMC.Functions.Notify({
    	message = message,
    	length = 4000,
    	notifType = type,
    	icon = '',
    	style = {},
    })
end
