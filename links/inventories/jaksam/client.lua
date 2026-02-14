if Link.inventory ~= 'jaksam_inventory' and Link.inventory ~= 'jaksam' then
    return
end

function GetItemCount(item_name)
    local count = exports['jaksam_inventory']:getTotalItemAmount(item_name)

    return count
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports['jaksam_inventory']:getInventory())
end