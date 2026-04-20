if Link.inventory ~= 'chezza' then
    return
end

function GetItemCount(item)
    return TriggerServerCallback('kq_link:callback:getItemCount', item)
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
