if Link.inventory ~= 'ps-inventory' and Link.inventory ~= 'ps' then
    return
end

function GetItemCount(item_name)
    return TriggerServerCallback('kq_link:callback:getItemCount', item_name)
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(TriggerServerCallback('kq_link:callback:getPlayerInventory'))
end