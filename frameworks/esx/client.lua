if Link.framework ~= 'esx' and Link.framework ~= 'es_extended' then
    return
end

ESX = nil

if not Link.esx.useOldExport then
    ESX = exports['es_extended']:getSharedObject()
else
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj)
                ESX = obj
            end)
            Citizen.Wait(0)
        end
    end)
end

Citizen.CreateThread(function()
    while ESX == nil or ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()

    PLAYER_DATA    = ESX.PlayerData
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(jobData)
    PLAYER_DATA.job = jobData
end)

function GetPlayerJob()
    return PLAYER_DATA.job.name
end

function NotifyViaFramework(message, type)
    -- ESX does not have the warning type by default. We will simply use the error type
    if type == 'warning' then
        type = 'error'
    end
    
    ESX.ShowNotification(message, type, 4000)
end
