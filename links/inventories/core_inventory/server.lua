if Link.inventory ~= 'core_inventory' and Link.inventory ~= 'core' then
    return
end

function GetPlayerItemData(player, item)
    local data = exports['core_inventory']:getItem(player, item)
    return data or {}
end

function GetPlayerItemCount(player, item)
    local data = GetPlayerItemData(player, item)
    return data.count or data.amount or 0
end

function AddPlayerItem(player, item, amount, meta)
    local success, response = exports['core_inventory']:addItem(player, item, amount or 1, meta)
    return success
end

function RemovePlayerItem(player, item, amount)
    local success, response = exports['core_inventory']:removeItem(player, item, amount or 1)
    return success
end

-- Stashes
function OpenCustomStash(player, stashId, label, slots, weight)
    exports['core_inventory']:openInventory(player, ('stash-' .. stashId):gsub(' ', ''), 'stash', 300, 300, true, nil, false)
end

function GetStashItems(stashId)
    return exports['core_inventory']:getInventory( ('stash-' .. stashId):gsub(' ', ''))
end
--
