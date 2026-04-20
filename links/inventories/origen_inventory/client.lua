if Link.inventory ~= 'origen_inventory' and Link.inventory ~= 'origen' then
    return
end

function GetItemCount(item)
    return exports.origen_inventory:GetItemCount(item) or 0
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports.origen_inventory:GetInventory())
end

function GetInventoryItems()
    return UseCache('kq_link:origen_inventory:items:client', function()
        return TriggerServerCallback('kq_link:getInventoryItems') or {}
    end, 60000)
end

function GetInventoryImagePath()
    return '', 'png'
end
