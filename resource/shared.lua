local cache = {}

-- Basic caching system
function SaveCache(key, data, lifespan)
    cache[key] = {
        data = data,
        maxAge = GetGameTimer() + (lifespan or 3000),
    }
end

function WipeCache(key)
    cache[key] = nil
end

function UseCache(key, cb, lifespan)
    if not cache[key] or cache[key]['maxAge'] < GetGameTimer() then
        local data = {cb()}
        SaveCache(key, data, lifespan)

        return table.unpack(data)
    end

    return table.unpack(cache[key]['data'])
end

-- UTILS

function Count(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

function Contains(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    
    return false
end

function Debug(...)
    if not Link.debugMode then
        return
    end
    print(...)
end
