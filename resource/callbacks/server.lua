local handlers = {}

function RegisterServerCallback(name, fn, secure)
    handlers[name] = {
        secure = secure,
        invoker = GetInvokingResource() or 'kq_link',
        callback = fn
    }
end

RegisterNetEvent("kq_link:server:callback")
AddEventHandler("kq_link:server:callback", function(name, id, invoker, ...)
    local src, handler = source, handlers[name]
    
    if not handler or not handler.callback then
        return TriggerClientEvent("kq_link:client:callback-response", src, name, id, false, "no handler")
    end
    
    if handler.secure and invoker ~= handler.invoker then
        return TriggerClientEvent("kq_link:client:callback-response", src, name, id, false, "unauthorized invoker " .. invoker)
    end
    
    local ok, a, b, c = pcall(handler.callback, src, ...)
    TriggerClientEvent("kq_link:client:callback-response", src, name, id, ok, a, b, c)
end)
