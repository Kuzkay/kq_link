if Link.dispatch.system ~= 'tk' then return end

function SendDispatchMessage(data)
    exports['tk_dispatch']:addCall({
        title = (data.message or ''),
        code = (data.code or '10-80'),
        priority = (data.priority or 'Important'),
        coords = data.coords or GetEntityCoords(PlayerPedId()),
        coordsOffset = data.coordsOffset,
        image = data.image,
        takePhoto = data.takePhoto,
        message = data.description,
        showLocation = (data.showLocation or true),
        showDirection = (data.showDirection or true),
        showGender = (data.showGender or true),
        showVehicle = (data.showVehicle or true),
        platePercentage = (data.platePercentage or 100),
        showWeapon = (data.showWeapon or true),
        showPerson = (data.showPerson or true),
        showNumber = (data.showNumber or true),
        removeTime = (data.removetime or 5000),
        showTime = (data.showTime or 5000),
        color = data.color,
        flash = (data.flash or false),
        playSound = (data.playSound or false),
        playSoundAll = (data.playSoundAll or false),
        jobs = (data.jobs or ''),
        blip = {
            sprite = (data.blip and data.blip.sprite) or 58,
            color = (data.blip and data.blip.color) or 3,
            scale = (data.blip and data.blip.scale) or 1.0,
            shortRange = false,
            name = (data.blip and (data.blip.text or data.blip.name)) or 'Dispatch Alert',
        },
    })
end

