RegisterNetEvent('kq_link:client:ox_inventory:openStash')
AddEventHandler('kq_link:client:ox_inventory:openStash', function(stashId)
    exports.ox_inventory:openInventory('stash', { id = stashId })
end)
