
-- Custom useful functions
function AddPlayerItemToFit(player, item, amount, meta)
    local gotItems = false

    while not gotItems and amount > 0 do
        gotItems = AddPlayerItem(player, item, amount, meta)

        if not gotItems then
            amount = amount - 1
        end
    end

    return gotItems, amount
end

-- Routing Bucket Tracking
local BUCKET_CHECK_BASE_INTERVAL = 4000
local BUCKET_CHECK_MIN_INTERVAL = 3000
local BUCKET_CHECK_MAX_INTERVAL = 8000
local playerBuckets = {}
local playerBucketRequestCooldown = {}

local function GetBucketCheckInterval()
    local playerCount = #GetPlayers()
    if playerCount <= 10 then
        return BUCKET_CHECK_BASE_INTERVAL
    elseif playerCount <= 50 then
        local scaled = BUCKET_CHECK_BASE_INTERVAL + (playerCount - 10) * 100
        return math.max(BUCKET_CHECK_MIN_INTERVAL, math.min(scaled, BUCKET_CHECK_MAX_INTERVAL))
    else
        return BUCKET_CHECK_MAX_INTERVAL
    end
end

Citizen.CreateThread(function()
    while true do
        local interval = GetBucketCheckInterval()
        Citizen.Wait(interval)

        for _, playerId in ipairs(GetPlayers()) do
            local id = tonumber(playerId)
            local bucket = GetPlayerRoutingBucket(id) or 0

            if playerBuckets[id] ~= bucket then
                playerBuckets[id] = bucket
                Player(id).state:set('kq_link:routingBucket', bucket, true)
            end
        end
    end
end)

AddEventHandler('playerDropped', function()
    playerBuckets[source] = nil
    playerBucketRequestCooldown[source] = nil
end)

local function SyncPlayerBucket(player)
    local bucket = GetPlayerRoutingBucket(player) or 0
    if playerBuckets[player] ~= bucket then
        playerBuckets[player] = bucket
        Player(player).state:set('kq_link:routingBucket', bucket, true)
    end
end

RegisterNetEvent('kq_link:server:requestBucketCheck', function()
    local player = source
    local now = GetGameTimer()

    if playerBucketRequestCooldown[player] and now - playerBucketRequestCooldown[player] < 2000 then
        return
    end
    playerBucketRequestCooldown[player] = now

    SyncPlayerBucket(player)
end)

Citizen.CreateThread(function()
    Citizen.Wait(500)
    for _, playerId in ipairs(GetPlayers()) do
        SyncPlayerBucket(tonumber(playerId))
    end
end)
