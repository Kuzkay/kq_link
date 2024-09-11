
function Count(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

function ShowTooltip(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    EndTextCommandDisplayHelp(0, 0, 1, 2500)
end

function KeybindTip(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    EndTextCommandDisplayHelp(0, 0, 1, 0)
end

-- This function is responsible for creating the text shown on the bottom of the screen
function DrawMissionText(text, time)
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time or 30000, 1)
end

function DrawFloatingText(coords, message)
    AddTextEntry('KqInputFloatingHelpNotification', message)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 2)
    BeginTextCommandDisplayHelp('KqInputFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function Draw2DText(x, y, text, scale)
    scale = scale * (Link.input.other.textScale or 1)
    SetTextFont(Link.input.other.textFont or 4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    EndTextCommandDisplayText(x, y)
end

function Draw3DText(coords, textInput, scaleX)
    scaleX = scaleX * (Link.input.other.textScale or 1)
    local camCoords = GetGameplayCamCoords()
    local dist = #(camCoords - coords)
    local scale = (1 / dist) * 20
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(scaleX * scale, scaleX * scale)
    SetTextFont(Link.input.other.textFont or 4)
    SetTextProportional(1)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(coords, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end
