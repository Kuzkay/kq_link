RegisterNetEvent('kq_link:client:codem-inventory:openStash')
AddEventHandler('kq_link:client:codem-inventory:openStash', function(stashId, weight, slots)
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', stashId, {
        maxweight = weight,
        slots = slots
    })
end)

if Link.inventory ~= 'codem-inventory' and Link.inventory ~= 'codem' then
    return
end

function GetItemCount(item_name)
    return TriggerServerCallback('kq_link:callback:getItemCount', item_name)
end

function GetPlayerInventory()
    return exports['codem-inventory']:getUserInventory()
end
