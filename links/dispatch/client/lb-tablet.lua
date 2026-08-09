if Link.dispatch.system ~= 'lb' then
    return
end

local function GetStreetLabel(coords)
    local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    return GetStreetNameFromHashKey(streetHash)
end

function SendDispatchMessage(data)
    local coords = data.coords or GetEntityCoords(PlayerPedId())

    exports['lb-tablet']:AddDispatch({
        priority = data.priority or 'medium',
        code = data.code or '10-80',
        title = data.message or '',
        description = data.description or '',
        location = {
            label = data.locationLabel or GetStreetLabel(coords),
            coords = coords,
        },
        time = os.time(),
        job = data.jobs or { 'police' },
        blip = {
            type = 'default',
            sprite = (data.blip.sprite or 58),
            color = (data.blip.color or 1),
            size = (data.blip.scale or 1.0),
            label = (data.blip.text or 'Dispatch Alert'),
        },
    })
end
