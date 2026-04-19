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
    local ok, raw = pcall(function() return exports['ak47_inventory']:Items() end)
    if not ok then return {} end
    local items = NormalizeItems(raw)
    if next(items) then itemsCache = items end
    return items
end

function GetInventoryImagePath()
    return '', 'png'
end
