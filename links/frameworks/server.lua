RegisterServerCallback('kq_link:callback:getItemCount', function(player, itemName)
    return GetPlayerItemCount(player, itemName)
end)

RegisterServerCallback('kq_link:callback:getPlayerInventory', function(player)
    return GetPlayerInventory(player)
end)