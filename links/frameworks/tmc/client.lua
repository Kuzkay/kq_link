if Link.framework ~= 'tmc' then
    return
end

TMC = exports.core:getCoreObject()
local currentJob, currentGrade = nil, nil

RegisterNetEvent('TMC:Client:OnPlayerSpawned', function()
    PLAYER_DATA = TMC.Functions.GetPlayerData()
    local job = GetPlayerJob()
    TriggerEvent('kq_link:jobUpdated', job)
    TriggerEvent('kq_link:playerLoaded')
end)

AddStateBagChangeHandler("JobTracking", nil, function(_, key, value)
    local xPlayerId = GetPlayerServerId(PlayerId())
    local newJob, newGrade = nil, nil
    local found = false

    for job, players in pairs(value or {}) do
        for i, v in ipairs(players) do
            if v.src == xPlayerId then
                newJob = job
                newGrade = v.grade
                found = true
                break
            end
        end
        if found then break end
    end

    if newJob ~= currentJob or newGrade ~= currentGrade then
        Debug(string.format("Job updated: %s > %s - Grade: %s > %s", currentJob, newJob, currentGrade, newGrade))
        currentJob, currentGrade = newJob, newGrade
        TriggerEvent('kq_link:jobUpdated', currentJob)
    end
end)

function GetPlayerJob()
    local job, grade = TMC.Functions.IsOnDuty()
    return job
end

function NotifyViaFramework(message, type)
    TMC.Functions.SimpleNotify(message, type)
end

if Link.inventory == 'framework' or Link.inventory == 'tmc-inventory' then
    function GetItemCount(item)
        local data = TMC.Functions.GetPlayerData()
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
        local data = TMC.Functions.GetPlayerData()
        return NormalizeInventoryOutput(data and data.items or {})
    end

    function GetInventoryItems()
        return {}
    end

    function GetInventoryImagePath()
        return '', 'png'
    end
end