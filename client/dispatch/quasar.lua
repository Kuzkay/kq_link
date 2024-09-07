if Link.dispatch.system ~= 'qs' then return end

function SendDispatchMessage(data)
    TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
        job = (data.jobs or {}),
        callLocation = data.coords or GetEntityCoords(PlayerPedId()),
        callCode = data.callCode,
        message = (data.message or ''),
        flashes = (data.flashes or false),          -- you can set to true if you need call flashing sirens...
        image = (data.url or ''),                    -- Url for image to attach to the call
        blip = {
            sprite = (data.blip.sprite or 58),
            scale = (data.blip.scale or 1.0),
            colour = (data.blip.colour or 3),
            flashes = (data.blip.flashes or false),
            text = (data.blip.text or 'Info Missing'),
            time = ((data.time * 1000) or 10000),
        },
        otherData = data.otherData
    })
end
