RegisterNetEvent('kq_link:client:ox_inventory:openStash')
AddEventHandler('kq_link:client:ox_inventory:openStash', function(stashId)
    exports.ox_inventory:openInventory('stash', { id = stashId })
end)

if Link.inventory ~= 'ox_inventory' and Link.inventory ~= 'ox' then
    return
end

function GetItemCount(item)
    return exports.ox_inventory:GetItemCount(item) or 0
end

function GetPlayerInventory()
    return NormalizeInventoryOutput(exports.ox_inventory:GetPlayerItems())
end
