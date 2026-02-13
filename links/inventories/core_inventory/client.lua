if Link.inventory ~= 'core_inventory' and Link.inventory ~= 'core' then
    return
end

function GetItemCount(item_name)
   local count = exports.core_inventory:getItemCount(item_name)

   return count and count > 0
end

function GetPlayerInventory()
    return exports.core_inventory:getInventory()
end