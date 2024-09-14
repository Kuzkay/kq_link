function Notify(message, type)
    if Link.notifications == 'framework' and NotifyViaFramework ~= nil then
        NotifyViaFramework(message, type)
        return
    elseif Link.notifications == 'codem-notification' then
        TriggerEvent('codem-notification:Create', message, type, nil, 4000)
        return
    elseif Link.notifications == 'okokNotify' then
        exports['okokNotify']:Alert(message, '', 4000, type, false)
        return
    elseif Link.notifications == 'mythic' then
        exports['mythic_notify']:DoHudText(type, message)
        return
    elseif Link.notifications == '17mov' then
        exports["17mov_Hud"]:ShowNotification(message, type)
        return
    elseif Link.notifications == 'ox' then
        lib.notify({
            title = message,
            type = type,
            duration = 4000,
        })
        return
    end
    
    
    if type == 'error' then
        message = '~r~' .. message
    elseif type == 'warning' then
        message = '~y~' .. message
    elseif type == 'success' then
        message = '~g~' .. message
    end
    
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    EndTextCommandDisplayHelp(0, 0, 0, -1)
end


RegisterNetEvent('kq_link:client:notify')
AddEventHandler('kq_link:client:notify', function(message, type)
    Notify(message, type or 'info')
end)
