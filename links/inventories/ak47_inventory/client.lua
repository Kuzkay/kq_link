if Link.inventory ~= 'ak47_inventory' and Link.inventory ~= 'ak47' then
    return
end

function GetItemCount(item)
    local data = exports['ak47_inventory']:Search('amount', item)

    return data.count or data.amount or 0
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports['ak47_inventory']:Items())
end

function GetInventoryItems()
    return UseCache('kq_link:ak47_inventory:items', function()
        return NormalizeItems(exports['ak47_inventory']:Items())
    end, 60000)
end

function GetInventoryImagePath()
    return '', 'png'
end
