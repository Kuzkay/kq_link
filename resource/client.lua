
local cachedRoutingBucket = LocalPlayer.state['kq_link:routingBucket'] or 0

AddStateBagChangeHandler('kq_link:routingBucket', ('player:%s'):format(GetPlayerServerId(PlayerId())), function(_, _, value)
    local newBucket = value or 0
    local oldBucket = cachedRoutingBucket
    cachedRoutingBucket = newBucket

    if oldBucket ~= newBucket then
        TriggerEvent('kq_link:routingBucketChanged', newBucket, oldBucket)
    end
end)

function GetRoutingBucket()
    return cachedRoutingBucket
end

-- Teleport Detection
local TELEPORT_CHECK_INTERVAL = 500
local TELEPORT_DISTANCE_THRESHOLD = 150.0 -- impossible to travel 150m in 500ms legitimately

local lastCoords = nil
local teleportCooldown = 0

local function CheckForTeleport()
    local now = GetGameTimer()
    if now < teleportCooldown then
        return false
    end

    local ped = PlayerPedId()
    if not ped or ped == 0 then
        return false
    end

    local coords = GetEntityCoords(ped)
    if coords.x == 0 and coords.y == 0 then
        return false
    end

    if not lastCoords then
        lastCoords = coords
        return false
    end

    local distance = #(coords - lastCoords)
    lastCoords = coords

    if distance > TELEPORT_DISTANCE_THRESHOLD then
        teleportCooldown = now + 3000
        return true
    end

    return false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(TELEPORT_CHECK_INTERVAL)

        if CheckForTeleport() then
            TriggerServerEvent('kq_link:server:requestBucketCheck')
        end
    end
end)
