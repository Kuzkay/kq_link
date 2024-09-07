if Link.dispatch.system ~= 'rcore' then return end

function SendDispatchMessage(data)
    local dispatchData = {
        code = data.code or '10-64',
        default_priority = data.default_priority or 'low',
        coords = data.coords or GetEntityCoords(PlayerPedId()),
        job = data.jobs or {},
        text = data.message or '',
        type = data.type or 'alerts',
        blip_time = data.blip.time,
        image = data.url or '',
        custom_sound = data.soundUrl,
        blip = {
            sprite = (data.blip.sprite or 58),
            colour = (data.blip.colour or 3),
            scale = (data.blip.scale or 1.0),
            text = (data.blip.text or 'Text Missing'),
            flashes = (data.flash or false),
            radius = (data.blip.radius or 0),
        }
    }
    TriggerServerEvent('rcore_dispatch:server:sendAlert', dispatchData)
end
