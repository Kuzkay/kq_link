if Link.inventory ~= 'jaksam_inventory' and Link.inventory ~= 'jaksam' then
    return
end

function GetItemCount(item)
    return exports['jaksam_inventory']:getTotalItemAmount(item) or 0
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports['jaksam_inventory']:getInventory())
end

local itemsCache
function GetInventoryItems()
    if itemsCache then return itemsCache end
    local ok, raw = pcall(function() return exports['jaksam_inventory']:getStaticItemsList() end)
    if not ok then return {} end
    local items = NormalizeItems(raw)
    if next(items) then itemsCache = items end
    return items
end

function GetInventoryImagePath()
    return 'nui://jaksam_inventory/_images/', 'png'
end
