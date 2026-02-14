if Link.inventory ~= 'origen_inventory' and Link.inventory ~= 'origen' then
    return
end

function GetItemCount(item_name)
    local count = exports.origen_inventory:GetItemCount(item_name)
    return count
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports.origen_inventory:GetInventory())
end