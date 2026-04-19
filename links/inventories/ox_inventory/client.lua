RegisterNetEvent('kq_link:client:ox_inventory:openStash')
AddEventHandler('kq_link:client:ox_inventory:openStash', function(stashId)
    exports.ox_inventory:openInventory('stash', { id = stashId })
end)

if Link.inventory ~= 'ox_inventory' and Link.inventory ~= 'ox' then
    return
end

function GetItemCount(item)
    return exports.ox_inventory:GetItemCount(item) or 0
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports.ox_inventory:GetPlayerItems())
end

local itemsCache
function GetInventoryItems()
    if itemsCache then return itemsCache end
    local ok, raw = pcall(function() return exports.ox_inventory:Items() end)
    if not ok then return {} end
    local items = NormalizeItems(raw)
    if next(items) then itemsCache = items end
    return items
end

function GetInventoryImagePath()
    return 'nui://ox_inventory/web/images/', 'png'
end
