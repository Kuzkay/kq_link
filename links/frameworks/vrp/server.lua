if Link.framework ~= 'vrp' then
    return
end

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

function GetPlayersWithJob(jobs)
    local matchingPlayers = {}
    local users = vRP.getUsers()
    local isTable = type(jobs) == 'table'
    
    for userId, _ in pairs(users) do
        local src = vRP.getUserSource(userId)
        if src then
            if isTable then
                for _, name in ipairs(jobs) do
                    if vRP.hasGroup(userId, name) then
                        table.insert(matchingPlayers, src)
                        break
                    end
                end
            elseif vRP.hasGroup(userId, jobs) then
                table.insert(matchingPlayers, src)
            end
        end
    end
    
    return matchingPlayers
end


function CanPlayerAfford(player, amount)
    local user_id = vRP.getUserId({player})
    if user_id then
        local player_money = vRP.getMoney({user_id})
        return player_money >= amount
    end
    return false
end

function AddPlayerMoney(player, amount, account)
    local user_id = vRP.getUserId({player})
    if user_id then
        if account == "bank" then
            vRP.giveBankMoney({user_id, amount})
        else
            vRP.giveMoney({user_id, amount})
        end
        return true
    end
    return false
end

function RemovePlayerMoney(player, amount)
    local user_id = vRP.getUserId({player})
    if user_id then
        if CanPlayerAfford(player, amount) then
            vRP.tryPayment({user_id, amount})
            return true
        end
    end
    return false
end

function GetPlayerItemData(player, item)
    local user_id = vRP.getUserId(player)
    local itemCount = vRP.getInventoryItemAmount(user_id, item)
    return {
        count = itemCount
    }
end

function GetPlayerItemData(player, item)
    local user_id = vRP.getUserId({player})
    if not user_id then
        return { count = 0 }
    end
    
    local itemCount = vRP.getInventoryItemAmount({user_id, item})
    return {
        count = itemCount or 0
    }
end

function GetPlayerItemCount(player, item)
    local data = GetPlayerItemData(player, item)
    return data.count
end

function AddPlayerItem(player, item, amount, meta)
    local user_id = vRP.getUserId({player})
    if not user_id then
        return false
    end
    
    vRP.giveInventoryItem({user_id, item, amount})
    return true
end

function RemovePlayerItem(player, item, amount)
    local user_id = vRP.getUserId({player})
    if not user_id then
        return false
    end
    
    return vRP.tryGetInventoryItem({user_id, item, amount})
end


function RegisterUsableItem(item, cb)
    return true -- needs to be defined on the item itself in VRP
end

function OpenCustomStash()
    -- Not available in vrp
    return true
end

function GetStashItems()
    -- Not available in vrp
    return {}
end
