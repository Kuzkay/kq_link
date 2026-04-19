if Link.inventory ~= 'ps-inventory' and Link.inventory ~= 'ps' then
    return
end

function GetItemCount(item)
    return TriggerServerCallback('kq_link:callback:getItemCount', item)
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(TriggerServerCallback('kq_link:callback:getPlayerInventory'))
end

local itemsCache
function GetInventoryItems()
    if itemsCache then return itemsCache end
    if not QBCore or not QBCore.Shared or type(QBCore.Shared.Items) ~= 'table' then
        return {}
    end
    local items = NormalizeItems(QBCore.Shared.Items)
    if next(items) then itemsCache = items end
    return items
end

function GetInventoryImagePath()
    return 'nui://ps-inventory/html/images/', 'png'
end
