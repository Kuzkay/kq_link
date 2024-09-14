if Link.dispatch.system ~= 'cd' then return end

function SendDispatchMessage(data)
    local dispatchData = exports['cd_dispatch']:GetPlayerInfo()
    TriggerServerEvent('cd_dispatch:AddNotification', {
        job_table = (data.jobs or {}),
        coords = data.coords or GetEntityCoords(PlayerPedId()),
        title = (data.message or ''),
        message = (data.description or ''),
        unique_id = dispatchData.unique_id,
        sound = 1,
        blip = {
            sprite = (data.blip.sprite or 58),
            scale = (data.blip.scale or 1.0),
            colour = (data.blip.color or 3),
            text = (data.blip.text or 'Dispatch Alert'),
            time = 2,
            radius = 0,
        }
    })
end
