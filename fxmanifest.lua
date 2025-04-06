fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'KuzQuality.com | Kuzkay'
description 'KuzQuality Link | Made to link existing frameworks and dependencies'
version '1.6.1'

server_scripts {
    -- RESOURCE BASE
    'resource/server.lua',
    
    -- FRAMEWORKS
    'links/frameworks/esx/server.lua',
    'links/frameworks/qbcore/server.lua',
    'links/frameworks/qbox/server.lua',
    'links/frameworks/vrp/server.lua',
    'links/frameworks/standalone/server.lua',
    
    -- INVENTORIES
    'links/inventories/ak47_inventory/server.lua',
    'links/inventories/codem-inventory/server.lua',
    'links/inventories/core_inventory/server.lua',
    'links/inventories/ox_inventory/server.lua',
    'links/inventories/ps-inventory/server.lua',
    'links/inventories/qs-inventory/server.lua',
    'links/inventories/origen_inventory/server.lua',

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
    'resource/interactions/client/client.lua',
    
    -- MINIGAMES
    'resource/minigames/progressbar.lua',
    'resource/minigames/sequence.lua',
    'resource/minigames/slowSequence.lua',
    
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
    
    
    -- INVENTORIES
    'links/inventories/ox_inventory/client.lua',
    'links/inventories/qs-inventory/client.lua',
    'links/inventories/codem-inventory/client.lua',
    
    -- EXPORTS
    'exports/client.lua',
}

escrow_ignore {
    '**',
}
