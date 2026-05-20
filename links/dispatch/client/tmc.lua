if Link.dispatch.system ~= 'tmc' then return end
local TMC = exports.core:getCoreObject()

function SendDispatchMessage(data)
    TMC.Functions.TriggerServerEvent('dispatch:server:addCall', {
        title = data.message,
        description = data.description,
        jobType = data.jobs,
        position = data.coords or GetEntityCoords(PlayerPedId()),
        urgency = 1,
        limits = {}
    })
end
