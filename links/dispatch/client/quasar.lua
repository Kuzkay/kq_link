if Link.dispatch.system ~= 'qs' then return end

function SendDispatchMessage(data)
    TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
        job = (data.jobs or {}),
        callLocation = data.coords or GetEntityCoords(PlayerPedId()),
        callCode = data.code,
        message = (data.message or ''),
        blip = {
            sprite = (data.blip.sprite or 58),
            scale = (data.blip.scale or 1.0),
            colour = (data.blip.color or 3),
            flashes = (data.blip.flash or false),
            text = (data.blip.text or 'Dispatch Alert'),
            time = 120000,
        },
    })
end
