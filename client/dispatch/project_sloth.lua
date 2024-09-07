if Link.dispatch.system ~= 'ps' then return end

function GetGender(ped)
    if GetEntityModel(ped) == `mp_m_freemode_01` then
        return 'male'
    elseif `mp_f_freemode_01` then
        return 'female'
    else
        return nil
    end
end

function GetStreetAndZone(coords)
    local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
    local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
    return street .. ", " .. zone
end

function SendDispatchMessage(data)
    local dispatchData = {
        message = data.message or "",
        codeName = data.dispatchCode or "NONE",
        code = data.code or '10-80',
        icon = data.icon or 'fas fa-question',
        priority = data.priority or 2,
        coords = data.coords or GetEntityCoords(PlayerPedId()),
        gender = GetGender(PlayerPedId()),
        street = GetStreetAndZone(data.coords),
        camId = data.camId or nil,
        color = data.firstColor or nil,
        callsign = data.callsign or nil,
        name = data.name or nil,
        vehicle = data.vehicle.model or nil,
        plate = data.vehicle.plate or nil,
        alertTime = data.alertTime or nil,
        doorCount = data.doorCount or nil,
        automaticGunfire = data.automaticGunfire or false,
        alert = {
            radius = data.radius or 0,
            recipientList = data.job,
            sprite = data.sprite or 1,
            color = data.color or 1,
            scale = data.scale or 0.5,
            length = data.length or 2,
            sound = data.sound or "Lose_1st",
            sound2 = data.sound2 or "GTAO_FM_Events_Soundset",
            offset = data.offset or "false",
            flash = data.flash or "false"
        },
        jobs = data.jobs or {},
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
