RegisterNetEvent('kq_link:client:qs-inventory:openStash')
AddEventHandler('kq_link:client:qs-inventory:openStash', function(stashId, stashData)
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', stashId, stashData)
end)
