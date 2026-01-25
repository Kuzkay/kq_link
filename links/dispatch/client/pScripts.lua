if Link.dispatch.system ~= 'p_mdt' and Link.dispatch.system ~= 'pScripts' then return end

function SendDispatchMessage(data)
    local coords = data.coords or GetEntityCoords(PlayerPedId())

    local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local street = streetHash and GetStreetNameFromHashKey(streetHash) or nil

    exports['p_mdt']:CreateAlert({
        priority = data.priority or 'medium',
        code = '10-35',
        title = data.message or '',
        description = data.description or '',
        street = street,
        coords = coords,

        jobs = data.jobs or {},

        blip = {
            sprite = (data.blip and data.blip.sprite) or 58,
            color = (data.blip and data.blip.color) or 3,
            scale = (data.blip and data.blip.scale) or 1.0,
            shortRange = false,
            name = (data.blip and (data.blip.text or data.blip.name)) or 'Dispatch Alert',
        },

        alertTime = 180,
    })

end
