RegisterServerCallback('kq_link:callback:getItemCount', function(player, itemName)
    return GetPlayerItemCount(player, itemName)
end)

RegisterServerCallback('kq_link:callback:getPlayerInventory', function(player)
    return GetPlayerInventory(player)
end)

RegisterServerCallback('kq_link:getInventoryItems', function(source, cb)
    if type(GetInventoryItems) ~= 'function' then
        return cb({})
    end
    cb(GetInventoryItems())
end)