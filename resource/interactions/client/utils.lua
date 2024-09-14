InputUtils = {}


function InputUtils.KeybindTip(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    EndTextCommandDisplayHelp(0, 0, 1, 0)
end

function InputUtils.DrawFloatingText(coords, message)
    AddTextEntry('KqInputFloatingHelpNotification', message)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 2)
    BeginTextCommandDisplayHelp('KqInputFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function InputUtils.Draw3DText(coords, textInput, scaleX)
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
