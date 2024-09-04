fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'KuzQuality.com | Kuzkay'
description 'KuzQuality Link | Made to link existing frameworks and dependencies'
version '1.0.0'

provide 'kq_link'

server_scripts {
    -- INVENTORIES
    'inventories/ox_inventory/server.lua',
    
    -- FRAMEWORKS
    -- esx
    'frameworks/esx/server.lua',
    -- qbcore
    'frameworks/qbcore/server.lua',
    -- qbox
    'frameworks/qbox/server.lua',
    -- standalone
    'frameworks/standalone/server.lua',
}

shared_scripts {
    'config.lua',
    'frameworks/shared.lua',
    '@ox_core/lib/init.lua',
}

client_scripts {
    'client/cache.lua',
    'client/input/utils.lua',
    'client/input/target.lua',
    'client/input/inputs.lua',
    
    'frameworks/client.lua',
    
    -- esx
    'frameworks/esx/client.lua',
    -- qbcore
    'frameworks/qbcore/client.lua',
    -- qbox
    '@qbx_core/modules/playerdata.lua',
    'frameworks/qbox/client.lua',
    
    -- standalone
    'frameworks/standalone/client.lua',
}

escrow_ignore {
    '**',
}
