exports('IsPropertyOwner', function(player, propertyId)
    return Housing.Call('IsPropertyOwner', player, propertyId) == true
end)
