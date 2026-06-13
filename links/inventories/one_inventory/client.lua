if Link.inventory ~= 'one_inventory' and Link.inventory ~= 'one' then
    return
end

function GetItemCount(item)
    return exports.one_inventory:GetItemCount(item) or 0
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports.one_inventory:GetInventoryItems() or {})
end

function GetInventoryItems()
    return NormalizeItems(exports.one_inventory:GetAllItemDefinitions())
end

function GetInventoryImagePath()
    return 'nui://one_inventory/web/images/', 'png'
end
