if Link.inventory ~= 'ps-inventory' and Link.inventory ~= 'ps' then
    return
end

function GetItemCount(item)
    return TriggerServerCallback('kq_link:callback:getItemCount', item)
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(TriggerServerCallback('kq_link:callback:getPlayerInventory'))
end

function GetInventoryItems()
    return UseCache('kq_link:ps-inventory:items', function()
        if not QBCore or not QBCore.Shared or type(QBCore.Shared.Items) ~= 'table' then
            return {}
        end
        return NormalizeItems(QBCore.Shared.Items)
    end, 60000)
end

function GetInventoryImagePath()
    return 'nui://ps-inventory/html/images/', 'png'
end
