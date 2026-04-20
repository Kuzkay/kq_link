if Link.inventory ~= 'ak47_inventory' and Link.inventory ~= 'ak47' then
    return
end

function GetItemCount(item)
    local data = exports['ak47_inventory']:Search('amount', item)

    return data.count or data.amount or 0
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports['ak47_inventory']:Items())
end

local itemsCache
function GetInventoryItems()
    if itemsCache then return itemsCache end
    local items = NormalizeItems(exports['ak47_inventory']:Items())
    if next(items) then itemsCache = items end
    return items
end

function GetInventoryImagePath()
    return '', 'png'
end
