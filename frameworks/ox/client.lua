if Link.framework ~= 'ox' and Link.framework ~= 'ox_core' then
    return
end

require '@ox_lib/init.lua'


function NotifyViaFramework(message, type)
    lib.notify({ description = message, type = type, duration = 4000 })
end

-- Not implemented by framework yet
