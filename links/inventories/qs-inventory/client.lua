RegisterNetEvent('kq_link:client:qs-inventory:openStash')
AddEventHandler('kq_link:client:qs-inventory:openStash', function(stashId)
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', stashId, {})
end)
