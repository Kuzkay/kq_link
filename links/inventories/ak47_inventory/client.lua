if Link.inventory ~= 'ak47_inventory' and Link.inventory ~= 'ak47' then
    return
end

function GetItemCount(item_name)
    local amount = exports['ak47_inventory']:Search('amount', item_name)

    return amount
end

function GetPlayerInventory()
    return exports['ak47_inventory']:Items()
end