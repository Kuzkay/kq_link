if Link.dispatch.system ~= 'tmc' then return end
local TMC = exports.core:getCoreObject()

function SendDispatchMessage(data)
    TMC.Functions.TriggerServerEvent('dispatch:server:addCall', {
        title = "Incoming Call",
        description = data.message,
        jobType = data.jobs,
        position = data.coords or GetEntityCoords(PlayerPedId()),
        urgency = 1,
        limits = {}
    })
end