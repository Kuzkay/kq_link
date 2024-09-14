if Link.inventory ~= 'ox_inventory' and Link.inventory ~= 'ox' then
    return
end

function RegisterUsableItem(...)
    return true -- Does not exist in this system
end

function GetPlayerItemData(player, item)
    local data = exports['ox_inventory']:GetItem(player, item)
    return data
end

function GetPlayerItemCount(player, item)
    local data = GetPlayerItemData(player, item)
    return data and (data.count or data.amount)
end

function AddPlayerItem(player, item, amount, meta)
    local success, response = exports['ox_inventory']:AddItem(player, item, amount or 1, meta)
    return success
end

function RemovePlayerItem(player, item, amount)
    local success, response = exports['ox_inventory']:RemoveItem(player, item, amount or 1)
    return success
end
