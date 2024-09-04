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
  --- 'none' / 'standalone'
  
  framework = 'auto',
  
  --- INVENTORY OPTIONS
  ------------------------
  --- 'framework' -- The native framework inventory system will be used
  ---
  --- 'ox_inventory' -- Ox inventory system will be used instead of the framework inventory system
  inventory = 'framework',
  
  -- Framework specific detail options (DO NOT REMOVE)
  esx = {
    useOldExport = false, -- Whether to use the old esx export method (via events)
  },
  ------------------------
  
  
  --- TARGET OPTIONS
  ------------------------
  input = {
    target = {
      enabled = true,
      system = 'ox_target' -- 'ox_target' or 'qb-target' or 'qtarget'  (Other systems might work as well)
    },
    
    -- Only applicable when target is disabled
    other = {
      -- '3d-text', 'top-left', 'help-text'
      inputType = '3d-text',
      
      textFont = 4,
      textScale = 1.0,
      
      outline = {
        enabled = true,
        color = {
          r = 255,
          g = 255,
          b = 255,
          a = 255,
        }
      }
    }
  }
}
