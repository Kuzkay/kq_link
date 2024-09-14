if Link.framework == 'auto' then
    
    function DetectAndSetFramework()
        local frameworks = {
            ['es_extended'] = 'esx',
            ['qb-core'] = 'qbcore',
            ['qbx-core'] = 'qbox',
            ['ox_core'] = 'ox',
        }
        
        for resource, config in pairs(frameworks) do
            if GetResourceState(resource) == 'started' then
                Link.framework = config
                print('set framework', config)
                return
            end
        end
        
        print('^1Framework not detected. If you are using a framework. Please configure it in the config.lua of ^6kq_link')
        Link.framework = 'none'
    end

    DetectAndSetFramework()
end
