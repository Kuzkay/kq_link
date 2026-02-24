if Link.dispatch.system ~= 'origen' then return end

function SendDispatchMessage(data)
    local job = data.jobs
    if type(job) == 'table' then
        job = job[1]
    end

    TriggerServerEvent('SendAlert:police', {
        job = (job or 'police'),
        coords = data.coords or GetEntityCoords(PlayerPedId()),
        title = (data.message or ''),
        message = (data.description or ''),
        type = 'GENERAL',
    })
end
