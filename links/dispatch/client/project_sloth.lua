if Link.dispatch.system ~= 'ps' then return end

function GetGender(ped)
    if GetEntityModel(ped) == GetHashKey('mp_m_freemode_01') then
        return 'male'
    elseif GetHashKey('mp_f_freemode_01') then
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
        jobs = data.jobs or {},
        message = data.description or "",
        codeName = "NONE",
        code = data.code or '10-35',
        icon = 'fas fa-question',
        priority = 2,
        coords = data.coords or GetEntityCoords(PlayerPedId()),
        gender = GetGender(PlayerPedId()),
        street = GetStreetAndZone(data.coords or GetEntityCoords(PlayerPedId())),
        name = data.message or nil,
        alertTime = 12,
        automaticGunfire = false,
        alert = {
            radius = 0,
            sprite = data.blip.sprite or 1,
            color = data.blip.color or 1,
            scale = data.blip.scale or 0.5,
            length = 2,
            sound = 'Lose_1st',
            sound2 = 'GTAO_FM_Events_Soundset',
            flash = data.blip.flash or false
        },
    }

    TriggerServerEvent('ps-dispatch:server:notify', dispatchData)
end
