if Link.inventory ~= 'ak47_inventory' and Link.inventory ~= 'ak47' then
    return
end

function GetItemCount(item_name)
    local data = exports['ak47_inventory']:Search('amount', item_name)

    return data.count or data.amount or 0
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports['ak47_inventory']:Items())
end