
RegisterNetEvent('kq_link:server:dispatch:sendAlert')
AddEventHandler('kq_link:server:dispatch:sendAlert', function(data)
    TriggerClientEvent('kq_link:client:dispatch:sendAlert', -1, data)
end)
