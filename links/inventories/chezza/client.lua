if Link.inventory ~= 'chezza' then
    return
end

function GetItemCount(item_name)
    return TriggerServerCallback('kq_link:callback:getItemCount', item_name)
end

function GetPlayerInventory()
    --No export by default
    return nil
end