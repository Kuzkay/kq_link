if Link.inventory ~= 'jaksam_inventory' and Link.inventory ~= 'jaksam' then
    return
end

function GetItemCount(item_name)
    local count = exports['jaksam_inventory']:getTotalItemAmount(item_name)

    return count and count > 0
end

function GetPlayerInventory()
    return exports['jaksam_inventory']:getInventory()
end