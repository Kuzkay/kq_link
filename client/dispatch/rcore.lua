if Link.dispatch.system ~= 'rcore' then return end

function SendDispatchMessage(data)
    local dispatchData = {
        code = data.code or '10-35',
        default_priority = 'medium',
        coords = data.coords or GetEntityCoords(PlayerPedId()),
        job = data.jobs or {},
        text = data.message or '',
        type = 'alerts',
        blip_time = 120000,
        blip = {
            sprite = (data.blip.sprite or 58),
            colour = (data.blip.color or 3),
            scale = (data.blip.scale or 1.0),
            text = (data.blip.text or 'Dispatch Alert'),
            flashes = (data.flash or false),
            radius = (data.blip.radius or 0),
        }
    }
    TriggerServerEvent('rcore_dispatch:server:sendAlert', dispatchData)
end
