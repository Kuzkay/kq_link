local function DetectAndSetFramework()
    if Link.framework ~= 'auto' then
        return
    end
    
    local frameworks = {
        ['es_extended'] = 'esx',
        ['qb-core'] = 'qbcore',
        ['qbx-core'] = 'qbox',
        ['ox_core'] = 'ox',
        ['vRP-framework'] = 'vrp',
    }
    
    for resource, config in pairs(frameworks) do
        if GetResourceState(resource) == 'started' then
            Link.framework = config
            Debug('set framework', config)
            return
        end
    end
    
    print('^1Framework not detected. If you are using a framework. Please configure it in the config.lua of ^6kq_link')
    Link.framework = 'none'
end

local function DetectAndSetInventory()
    if Link.inventory ~= 'auto' then
        return
    end
    
    Link.inventory = 'framework'
    
    local inventories = {
        ['ox_inventory'] = 'ox_inventory',
        ['qs-inventory'] = 'qs-inventory',
        ['ps-inventory'] = 'ps-inventory',
        ['ak47_inventory'] = 'ak47_inventory',
        ['core_inventory'] = 'core_inventory',
        ['minventory'] = 'codem-inventory',
        ['inventory'] = 'chezza',
    }
    
    for resource, config in pairs(inventories) do
        if GetResourceState(resource) == 'started' then
            Link.inventory = config
            Debug('set inventory', config)
            return
        end
    end
end

local function DetectAndSetVehicleKeys()
    if Link.vehiclekeys ~= 'auto' then
        return
    end

    local vehiclekeys = {
        ['qbx_vehiclekeys'] = 'qbx_vehiclekeys',
        ['qb-vehiclekeys'] = 'qb-vehiclekeys',
        ['wasabi_carlock'] = 'wasabi_carlock',
        ['vehicles_keys'] = 'jaksam',
        ['MrNewbVehicleKeys'] = 'mrnewb',
        ['Renewed-Vehiclekeys'] = 'renewed',
    }

    for resource, config in pairs(vehiclekeys) do
        if GetResourceState(resource) == 'started' then
            Link.vehiclekeys = config
            Debug('set vehiclekeys', config)
            return
        end
    end

    Link.vehiclekeys = 'standalone'
end

DetectAndSetFramework()
DetectAndSetInventory()
DetectAndSetVehicleKeys()
