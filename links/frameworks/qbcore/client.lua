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
    TriggerEvent('kq_link:jobUpdated', PLAYER_DATA.job.name)
    TriggerEvent('kq_link:playerLoaded')
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(jobData)
    PLAYER_DATA.job = jobData
    TriggerEvent('kq_link:jobUpdated', PLAYER_DATA.job.name)
end)

function GetPlayerJob()
    return PLAYER_DATA.job.name
end

function NotifyViaFramework(message, type)
    QBCore.Functions.Notify(message, type, 4000)
end

if Link.inventory == 'framework' or Link.inventory == 'qb-inventory' then
    function GetItemCount(item)
        local data = QBCore.Functions.GetPlayerData()
        local items = data and data.items or {}
        local count = 0

        for _, v in pairs(items) do
            if v and v.name == item then
                count = count + (v.amount or v.count or 0)
            end
        end

        return count
    end

    function GetPlayerInventory()
        local data = QBCore.Functions.GetPlayerData()
        return NormalizeInventoryOutput(data and data.items or {})
    end

    function GetInventoryItems()
        return UseCache('kq_link:qb-inventory:items', function()
            if not QBCore or not QBCore.Shared or type(QBCore.Shared.Items) ~= 'table' then
                return {}
            end
            return NormalizeItems(QBCore.Shared.Items)
        end, 60000)
    end

    function GetInventoryImagePath()
        return 'nui://qb-inventory/html/images/', 'png'
    end
end