if Link.dispatch.system ~= 'cd' then return end

function SendDispatchMessage(data)
    local dispatchData = exports['cd_dispatch']:GetPlayerInfo()
    TriggerServerEvent('cd_dispatch:AddNotification', {
        job_table = (data.jobs or {}),
        coords = data.coords or GetEntityCoords(PlayerPedId()),
        title = (data.title or ''),
        message = (data.message or ''),
        flash = (data.flash or 0),
        unique_id = dispatchData.unique_id,
        sound = (data.sound or 1),
        blip = {
            sprite = (data.blip.sprite or 58),
            scale = (data.blip.scale or 1.0),
            colour = (data.blip.colour or 3),
            flashes = (data.blip.flashes or false),
            text = (data.blip.text or 'Text Missing'),
            time = (data.blip.time or 5),
            radius = (data.blip.radius or 0)
        }
    })
end
