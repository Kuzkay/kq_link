if Link.inventory ~= 'ps-inventory' and Link.inventory ~= 'ps' then
    return
end

function GetItemCount(item_name)
    local hasItem = exports['ps-inventory']:HasItem(item_name)
    return hasItem == true
end

function GetPlayerInventory()
    --No such export by default
    return nil
end