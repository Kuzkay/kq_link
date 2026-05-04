RegisterNetEvent('kq_link:client:gs-inventory:openStash')
AddEventHandler('kq_link:client:gs-inventory:openStash', function(stashId, label, slots, maxWeight)
    if GetResourceState('gs-inventory') ~= 'started' then return end
    exports['gs-inventory']:OpenStorage(stashId, label or 'Storage', slots, maxWeight)
end)

if Link.inventory ~= 'gs-inventory' and Link.inventory ~= 'gs_inventory' then
    return
end

function GetItemCount(item)
    return TriggerServerCallback('kq_link:callback:getItemCount', item)
end

function GetPlayerInventory()
    return TriggerServerCallback('kq_link:callback:getPlayerInventory')
end
