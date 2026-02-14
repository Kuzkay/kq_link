if Link.inventory ~= 'jaksam_inventory' and Link.inventory ~= 'jaksam' then
    return
end

function GetItemCount(item)
    return exports['jaksam_inventory']:getTotalItemAmount(item) or 0
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports['jaksam_inventory']:getInventory())
end
