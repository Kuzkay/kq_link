if Link.inventory ~= 'chezza' then
    return
end

function GetItemCount(item)
    return UseCache('kq_link:count:' .. item, function()
        return TriggerServerCallback('kq_link:callback:getItemCount', item) or 0
    end, 30000)
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(TriggerServerCallback('kq_link:callback:getPlayerInventory'))
end

function GetInventoryItems()
    return UseCache('kq_link:chezza:items', function()
        return TriggerServerCallback('kq_link:getInventoryItems') or {}
    end, 60000)
end

function GetInventoryImagePath()
    return 'nui://inventory/html/img/items/', 'png'
end
