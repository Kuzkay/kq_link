if Link.inventory ~= 'origen_inventory' and Link.inventory ~= 'origen' then
    return
end

function GetItemCount(item_name)
    local count = exports.origen_inventory:GetItemCount(item_name)
    return count and count > 0
end

function GetPlayerInventory()
    return exports.origen_inventory:GetInventory()
end