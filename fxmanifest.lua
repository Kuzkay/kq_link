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
    'inventories/qs-inventory/server.lua',
    
    -- FRAMEWORKS
    -- esx
    'frameworks/esx/server.lua',
    -- qbcore
    'frameworks/qbcore/server.lua',
    -- qbox
    'frameworks/qbox/server.lua',
    -- standalone
    'frameworks/standalone/server.lua',
    
    --
    'server/server.lua',
    
    'server/exports.lua',
}

shared_scripts {
    'config.lua',
    'frameworks/shared.lua',
    
    '@ox_lib/init.lua',
    '@ox_core/lib/init.lua',
}

client_scripts {
    'client/cache.lua',
    
    'client/functions.lua',
    'client/client.lua',
    
    'client/interactions/utils.lua',
    'client/interactions/target.lua',
    'client/interactions/interactions.lua',
    
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
