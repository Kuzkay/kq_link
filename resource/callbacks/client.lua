local pending = {}

math.randomseed(GetGameTimer())

local function GenerateReqId()
    local random, str_fmt = math.random, string.format
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and random(0, 0xF) or random(8, 0xB)
        return str_fmt('%x', v)
    end)
end

function TriggerServerCallback(name, ...)
    local timeout = 10000
    local invoker = GetInvokingResource() or 'kq_link'

    local id, co = GenerateReqId(), coroutine.running()

    pending[id] = function(ok, ...)
        pending[id] = nil
        coroutine.resume(co, ok, ...)
    end

    Citizen.SetTimeout(timeout, function()
        if pending[id] then
            pending[id] = nil
            coroutine.resume(co, false, ("Callback [%s] timed out"):format(name))
        end
    end)

    TriggerServerEvent('kq_link:server:callback', name, id, invoker, ...)

    local ret = { coroutine.yield() }
    local ok = ret[1]
    if not ok then
        print('^1' .. ret[2], 2)
        return nil
    end

    if #ret > 1 then
        return table.unpack(ret, 2)
    end

    return nil
end

RegisterNetEvent('kq_link:client:callback-response')
AddEventHandler('kq_link:client:callback-response', function(name, id, ok, ...)
    local cb = pending[id]
    if cb then
        cb(ok, ...)
    else
        print('^1Callback not found', id, name)
    end
end)
