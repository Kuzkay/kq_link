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
    return TriggerServerCallback('kq_link:callback:getItemCount', item)
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports['codem-inventory']:getUserInventory())
end

local itemsCache
function GetInventoryItems()
    if itemsCache then return itemsCache end
    local items = NormalizeItems(exports['codem-inventory']:GetItemList())
    if next(items) then itemsCache = items end
    return items
end

function GetInventoryImagePath()
    return 'nui://codem-inventory/html/itemimages/', 'png'
end
