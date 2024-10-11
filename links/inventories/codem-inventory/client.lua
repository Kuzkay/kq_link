RegisterNetEvent('kq_link:client:codem-inventory:openStash')
AddEventHandler('kq_link:client:codem-inventory:openStash', function(stashId, weight, slots)
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', stashId, {
        maxweight = weight,
        slots = slots
    })
end)
