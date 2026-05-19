if Link.framework ~= 'ox' and Link.framework ~= 'ox_core' then
    return
end

function NotifyViaFramework(message, type)
    lib.notify({ description = message, type = type, duration = 4000 })
end

AddEventHandler('ox:playerLoaded', function(playerId, isNew)
    TriggerEvent('kq_link:playerLoaded')
end)

-- Not implemented by framework yet
function GetPlayerJob()
    return nil
end