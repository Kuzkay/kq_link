Link = {}


----------------------------------
--- BASE SETTINGS
----------------------------------

Link = {
    -- Whether to enable debug options such as extra logging and target meshes
    debugMode = false,

    --- FRAMEWORK OPTIONS
    ------------------------
    --- Options:
    --- 'auto' -- This will automatically detect your framework. I still recommend setting it to the correct one to be safe
    ---
    --- 'esx'
    --- 'qb-core'
    --- 'ox'
    --- 'qbox'
    --- 'vrp' -- You will need to add the necessary vrp imports to the fxmanifest.
    --- 'none' / 'standalone'

    framework = 'auto',


    -- Framework specific detail options (DO NOT REMOVE)
    esx = {
        useOldExport = false, -- Whether to use the old esx export method (via events)
    },
}

--- INVENTORY OPTIONS
------------------------
--- 'auto' -- The script will automatically find the inventory system
--- 'framework' -- The native framework inventory system will be used
---
--- 'ox_inventory' -- Ox inventory system
--- 'qs-inventory' -- Quasar inventory system
--- 'ps-inventory' -- Project Sloth inventory system
--- 'codem-inventory' -- CodeM inventory system
--- 'core_inventory' -- Core inventory system (c8re)
--- 'ak47_inventory' -- AK47 inventory system (menan)
--- 'origen_inventory' -- Origen inventory system
--- 'chezza' -- Chezza inventory system (inventory)
Link.inventory = 'auto'


--- NOTIFICATION OPTIONS
------------------------
--- 'framework' -- The native framework notification system will be used
--- 'ox' -- Notification system made by OX
--- 'codem-notification' -- Notifications system made by CodeM
--- 'okokNotify' -- Notifications system made by okok
--- 'mythic' -- Notifications system made by mythic
--- '17mov' -- Notifications system made by 17Movement
---
--- 'standalone' -- A standalone solution will be used for notifications (top left display)
Link.notifications = 'standalone'


------------------------
--- INTERACTIONS INPUT OPTIONS
------------------------
Link.input = {
    target = {
        -- Whether to use a targeting system
        enabled = false,
        --- 'ox_target' -- ox targeting system
        --- 'qb-target' -- QBCore targeting system
        --- 'qtarget' -- The classic qtarget system commonly used in esx
        --- 'interact' -- Interact system by darktrovx
        ---
        --- You may also try entering the name of other targeting systems, as they often use very similar exports.
        system = 'ox_target'
    },

    -- Only applicable when target is disabled
    other = {
        -- The default option "kq" is our custom light-weight interaction system.
        -- When multiple options are available, scroll through them using your scroll or arrow keys
        -- 'kq', '3d-text', 'top-left', 'help-text'
        inputType = 'kq',

        textFont = 4,
        textScale = 1.0,

        outline = {
            enabled = false, -- May cause issues in recent FiveM builds
            color = {
                r = 255,
                g = 255,
                b = 255,
                a = 255,
            }
        }
    }
}

--- DISPATCH OPTIONS
------------------------
--- 'cd' -- Dispatch system made by Codesign
--- 'ps' -- Dispatch system made by Project Sloth
--- 'qs' -- Dispatch system made by Quasar
--- 'rcore' -- Dispatch system made by Rcore
---
--- 'standalone' -- Built in dispatch system
Link.dispatch = {
    system = 'standalone'
}
