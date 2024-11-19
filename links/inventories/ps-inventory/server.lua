if Link.inventory ~= 'ps-inventory' and Link.inventory ~= 'ps' then
    return
end

function GetPlayerItemData(player, item)
    local data = exports['ps-inventory']:GetItemByName(player, item)
    return data
end

function GetPlayerItemCount(player, item)
    return GetPlayerItemData(player, item).amount or 0
end

function AddPlayerItem(player, item, amount, meta)
    return exports['ps-inventory']:AddItem(player, item, amount, nil, meta)
end

function RemovePlayerItem(player, item, amount)
    return exports['ps-inventory']:RemoveItem(player, item, amount, nil)
end

-- Stashes
function OpenCustomStash(player, stashId, label, slots, weight)
    stashId = ('stash_' .. stashId):gsub('-', '_')
    
    local data = { label = label, maxweight = weight, slots = slots }
    exports['ps-inventory']:OpenInventory(player, stashId, data)
end

function GetStashItems(stashId)
    stashId = ('stash_' .. stashId):gsub('-', '_')
    
    exports['ps-inventory']:GetStashItems(stashId)
end
--
