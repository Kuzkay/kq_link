RegisterNetEvent('kq_link:client:qs-inventory:openStash')
AddEventHandler('kq_link:client:qs-inventory:openStash', function(stashId, stashData)
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', stashId, stashData)
    TriggerEvent("inventory:client:SetCurrentStash", stashId)
end)

if Link.inventory ~= 'qs-inventory' and Link.inventory ~= 'qs' then
    return
end

local itemsCache
function GetInventoryItems()
    if itemsCache then return itemsCache end
    local ok, raw = pcall(function() return exports['qs-inventory']:GetItemList() end)
    if not ok then return {} end
    local items = NormalizeItems(raw)
    if next(items) then itemsCache = items end
    return items
end

function GetInventoryImagePath()
    return 'nui://qs-inventory/html/images/', 'png'
end
