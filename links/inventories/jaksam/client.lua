if Link.inventory ~= 'jaksam_inventory' and Link.inventory ~= 'jaksam' then
    return
end

function GetItemCount(item)
    return exports['jaksam_inventory']:getTotalItemAmount(item) or 0
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports['jaksam_inventory']:getInventory())
end

function GetInventoryItems()
    return UseCache('kq_link:jaksam_inventory:items', function()
        return NormalizeItems(exports['jaksam_inventory']:getStaticItemsList())
    end, 60000)
end

function GetInventoryImagePath()
    return 'nui://jaksam_inventory/_images/', 'png'
end
