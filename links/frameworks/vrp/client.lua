if Link.framework ~= 'vrp' then
    return
end

function GetItemCount(item)
    return UseCache('kq_link:count:' .. item, function()
        return TriggerServerCallback('kq_link:callback:getItemCount', item) or 0
    end, 30000)
end

function GetPlayerInventory()
    return {}
end

function GetInventoryItems()
    return {}
end

function GetInventoryImagePath()
    return '', 'png'
end
