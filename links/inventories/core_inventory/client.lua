if Link.inventory ~= 'core_inventory' and Link.inventory ~= 'core' then
    return
end

function GetItemCount(item)
   return exports.core_inventory:getItemCount(item) or 0
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports.core_inventory:getInventory())
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
