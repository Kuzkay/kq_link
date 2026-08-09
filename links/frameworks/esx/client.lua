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

    PLAYER_DATA = ESX.PlayerData
    TriggerEvent('kq_link:jobUpdated', PLAYER_DATA.job.name)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(jobData)
    PLAYER_DATA.job = jobData
    TriggerEvent('kq_link:jobUpdated', PLAYER_DATA.job.name)
end)

AddEventHandler('esx:onPlayerSpawn', function ()
    TriggerEvent('kq_link:playerLoaded')
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

if Link.inventory == 'framework' then
    function GetItemCount(item)
        local data = ESX.GetPlayerData()
        local inventory = data and data.inventory
        if not inventory then
            return 0
        end

        for _, v in pairs(inventory) do
            if v.name == item then
                return v.count or v.amount or 0
            end
        end

        return 0
    end

    function GetPlayerInventory()
        local data = ESX.GetPlayerData()
        return NormalizeInventoryOutput(data and data.inventory or {})
    end

    function GetInventoryItems()
        return UseCache('kq_link:esx-framework:items', function()
            return TriggerServerCallback('kq_link:getInventoryItems') or {}
        end, 60000)
    end

    function GetInventoryImagePath()
        return '', 'png'
    end
end
