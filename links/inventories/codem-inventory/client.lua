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

function GetItemCount(item)
    return UseCache('kq_link:count:' .. item, function()
        return TriggerServerCallback('kq_link:callback:getItemCount', item) or 0
    end, 30000)
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports['codem-inventory']:getUserInventory())
end

function GetInventoryItems()
    return UseCache('kq_link:codem-inventory:items', function()
        return NormalizeItems(exports['codem-inventory']:GetItemList())
    end, 60000)
end

function GetInventoryImagePath()
    return 'nui://codem-inventory/html/itemimages/', 'png'
end
