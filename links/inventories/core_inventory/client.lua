if Link.inventory ~= 'core_inventory' and Link.inventory ~= 'core' then
    return
end

function GetItemCount(item)
   return exports.core_inventory:getItemCount(item) or 0
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports.core_inventory:getInventory())
end
