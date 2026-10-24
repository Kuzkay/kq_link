Housing = {
    adapters = {},
    order = {},

    requiredFunctions = {
        client = {
            'GetCurrentProperty',
        },
        server = {
            'IsPropertyOwner',
        },
    },
}

function Housing.Register(name, adapter)
    local required = IsDuplicityVersion() and Housing.requiredFunctions.server or Housing.requiredFunctions.client

    local missing = {}
    for _, fn in ipairs(required) do
        if type(adapter[fn]) ~= 'function' then
            missing[#missing + 1] = fn
        end
    end

    if #missing > 0 then
        error(('Housing adapter "%s" is missing: %s'):format(name, table.concat(missing, ', ')))
    end

    if not Housing.adapters[name] then
        Housing.order[#Housing.order + 1] = name
    end

    adapter.name = name
    adapter.resource = adapter.resource or name
    Housing.adapters[name] = adapter
end

function Housing.DetectAndSet()
    if Link.housing == 'standalone' or Link.housing == 'none' then
        return
    end

    if Link.housing ~= 'auto' then
        if not Housing.adapters[Link.housing] then
            print(('^1Unknown housing "%s" in the config.lua of ^6kq_link^1. Available: %s^0'):format(Link.housing, table.concat(Housing.order, ', ')))
            Link.housing = 'standalone'
        end
        return
    end

    for _, name in ipairs(Housing.order) do
        if GetResourceState(Housing.adapters[name].resource) == 'started' then
            Link.housing = name
            Debug('set housing', name)
            return
        end
    end

    print('^3Housing system not detected. If you are using a housing script, please configure it in the config.lua of ^6kq_link')
    Link.housing = 'standalone'
end

function Housing.Get()
    return Housing.adapters[Link.housing]
end

function Housing.Call(name, ...)
    local adapter = Housing.Get()
    if not adapter then
        return nil
    end

    local ok, result = pcall(adapter[name], ...)
    if not ok then
        print(('^1Housing adapter "%s" failed in %s: %s^0'):format(adapter.name, name, tostring(result)))
        return nil
    end

    return result
end

Citizen.SetTimeout(2000, function()
    Housing.DetectAndSet()
end)
