RegisterNetEvent('kq_link:client:tgiann-inventory:openStash')
AddEventHandler('kq_link:client:tgiann-inventory:openStash', function(stashId)
    exports['tgiann-inventory']:OpenInventory('stash', stashId)
end)

if Link.inventory ~= 'tgiann-inventory' and Link.inventory ~= 'tgiann' then
    return
end

function GetItemCount(item)
    return exports["tgiann-inventory"]:GetItemCount(item) or 0
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports["tgiann-inventory"]:Items())
end

local itemsCache
function GetInventoryItems()
    if itemsCache then return itemsCache end
    local items = NormalizeItems(exports['tgiann-inventory']:GetItemList())
    if next(items) then itemsCache = items end
    return items
end

function GetInventoryImagePath()
    return 'nui://tgiann-inventory/inventory_images/images/', 'webp'
end
