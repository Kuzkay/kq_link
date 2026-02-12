RegisterNetEvent('kq_link:client:codem-inventory:openStash')
AddEventHandler('kq_link:client:codem-inventory:openStash', function(stashId, weight, slots)
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', stashId, {
        maxweight = weight,
        slots = slots
    })
end)

if Link.inventory ~= 'codem-inventory' and Link.inventory ~= 'codem' then
    return
end

function IsPlayerCarryingItem(item_name)
    --No export by default
    return nil
end

function GetPlayerInventory()
    return exports['codem-inventory']:getUserInventory()
end