function Notify(message, type)
    if Link.notifications == 'framework' then
        NotifyViaFramework(message, type)
        return
    end

    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    EndTextCommandDisplayHelp(0, 0, 0, -1)
end

RegisterNetEvent('kq_link:client:notify')
AddEventHandler('kq_link:client:notify', function(message, type)
    Notify(message, type or 'info')
end)
