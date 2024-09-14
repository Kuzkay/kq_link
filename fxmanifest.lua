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
    'links/frameworks/esx/server.lua',
    'links/frameworks/qbcore/server.lua',
    'links/frameworks/qbox/server.lua',
    'links/frameworks/standalone/server.lua',
    
    -- INVENTORIES
    'links/inventories/ox_inventory/server.lua',
    'links/inventories/qs-inventory/server.lua',

    -- DISPATCH
    'links/dispatch/server/server.lua',
    
    -- BASE RESOURCE
    'resource/server.lua',
    
    -- EXPORTS
    'exports/server.lua',
}

shared_scripts {
    'config.lua',
    'resource/shared.lua',
    'links/frameworks/shared.lua',

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
    'links/notifications/client/client.lua',
    
    
    -- DISPATCH
    'links/dispatch/client/*.lua',
    
    -- FRAMEWORKS
    'links/frameworks/client.lua',
    
    'links/frameworks/esx/client.lua',
    'links/frameworks/qbcore/client.lua',
    'links/frameworks/qbox/client.lua',
    'links/frameworks/standalone/client.lua',
    
    -- EXPORTS
    'exports/client.lua',
}

escrow_ignore {
    '**',
}
