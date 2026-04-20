RegisterNetEvent('kq_link:client:qs-inventory:openStash')
AddEventHandler('kq_link:client:qs-inventory:openStash', function(stashId, stashData)
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', stashId, stashData)
    TriggerEvent("inventory:client:SetCurrentStash", stashId)
end)

if Link.inventory ~= 'qs-inventory' and Link.inventory ~= 'qs' then
    return
end

function GetInventoryItems()
    return UseCache('kq_link:qs-inventory:items', function()
        return NormalizeItems(exports['qs-inventory']:GetItemList())
    end, 60000)
end

function GetInventoryImagePath()
    return 'nui://qs-inventory/html/images/', 'png'
end
