RegisterNetEvent('kq_link:client:tgiann-inventory:openStash')
AddEventHandler('kq_link:client:tgiann-inventory:openStash', function(stashId)
    exports['tgiann-inventory']:OpenInventory('stash', stashId)
end)

if Link.inventory ~= 'tgiann-inventory' and Link.inventory ~= 'tgiann' then
    return
end

function GetItemCount(item)
    return exports["tgiann-inventory"]:GetItemCount(item) or 0
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports["tgiann-inventory"]:Items())
end
