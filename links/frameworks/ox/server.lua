if Link.framework ~= 'ox' and Link.framework ~= 'ox_core' then
    return
end

local Ox = require '@ox_core/lib/init.lua'

function CanPlayerAfford(player, amount)
    -- Not implemented by framework
    return true
end

function AddPlayerMoney(player, amount, account)
    -- Not implemented by framework
    return true
end

function RemovePlayerMoney(player, amount)
    -- Not implemented by framework
    return true
end

if Link.inventory == 'framework' then
    Link.inventory = 'ox_inventory'
end

function GetPlayerCharacterId(player)
    local xPlayer = Ox.GetPlayer(tonumber(player))
    
    return xPlayer.charId
end
