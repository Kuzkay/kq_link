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