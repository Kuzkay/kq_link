if Link.inventory ~= 'qs-inventory' and Link.inventory ~= 'qs' then
    return
end

function RegisterUsableItem(...)
    return true -- Does not exist in this system
end

function GetPlayerItemData(player, item)
    local data = exports['qs-inventory']:GetItemTotalAmount(player, item)
    return { amount = data }
end

function GetPlayerItemCount(player, item)
    return exports['qs-inventory']:GetItemTotalAmount(player, item) or 0
end

function AddPlayerItem(player, item, amount, meta)
    return exports['qs-inventory']:AddItem(player, item, amount, nil, meta)
end

function RemovePlayerItem(player, item, amount)
    return exports['qs-inventory']:RemoveItem(player, item, amount, nil, meta)
end
