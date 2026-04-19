if Link.inventory ~= 'origen_inventory' and Link.inventory ~= 'origen' then
    return
end

function GetItemCount(item)
    return exports.origen_inventory:GetItemCount(item) or 0
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports.origen_inventory:GetInventory())
end

local itemsCache
function GetInventoryItems()
    if itemsCache then return itemsCache end
    local items = TriggerServerCallback('kq_link:getInventoryItems') or {}
    if next(items) then itemsCache = items end
    return items
end

function GetInventoryImagePath()
    return '', 'png'
end
