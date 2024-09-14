fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'KuzQuality.com | Kuzkay'
description 'KuzQuality Link | Made to link existing frameworks and dependencies'
version '1.0.0'

provide 'kq_link'

server_scripts {
    -- RESOURCE BASE
    'resource/server.lua',
    
    -- FRAMEWORKS
    'frameworks/esx/server.lua',
    'frameworks/qbcore/server.lua',
    'frameworks/qbox/server.lua',
    'frameworks/standalone/server.lua',
    
    -- INVENTORIES
    'inventories/ox_inventory/server.lua',
    'inventories/qs-inventory/server.lua',

    -- DISPATCH
    'dispatch/server/server.lua',
    
    -- BASE RESOURCE
    'resource/server.lua',
    
    -- EXPORTS
    'exports/server.lua',
}

shared_scripts {
    'config.lua',
    'resource/shared.lua',
    'frameworks/shared.lua',

    '@ox_lib/init.lua',
    '@ox_core/lib/init.lua',
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    
    -- RESOURCE BASE
    'resource/client.lua',
    
    -- INTERACTIONS
    'resource/interactions/client/utils.lua',
    'resource/interactions/client/target.lua',
    'resource/interactions/client/interactions.lua',
    
    -- NOTIFICATIONS
    'notifications/client/client.lua',
    
    
    -- DISPATCH
    'dispatch/client/*.lua',
    
    -- FRAMEWORKS
    'frameworks/client.lua',
    
    'frameworks/esx/client.lua',
    'frameworks/qbcore/client.lua',
    'frameworks/qbox/client.lua',
    'frameworks/standalone/client.lua',
    
    -- EXPORTS
    'exports/client.lua',
}

escrow_ignore {
    '**',
}
