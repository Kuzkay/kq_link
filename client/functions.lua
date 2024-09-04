
function Notify(message, success)
    if Link.notifications == 'framework' then
        NotifyViaFramework(message, success)
        return
    end
    
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    EndTextCommandDisplayHelp(0, 0, 0, -1)
end

RegisterNetEvent('kq_link:client:notify')
AddEventHandler('kq_link:client:notify', function(message, success)
    Notify(message, success or true)
end)
