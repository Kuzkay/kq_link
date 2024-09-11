
function AddPlayerItemToFit(player, item, amount)
    local gotItems = false
    
    while not gotItems and amount > 0 do
        gotItems = AddPlayerItem(player, item, amount)
        
        if not gotItems then
            amount = amount - 1
        end
    end
    
    return gotItems, amount
end

RegisterNetEvent('kq_link:server:dispatch:sendAlert')
AddEventHandler('kq_link:server:dispatch:sendAlert', function(data)
  TriggerClientEvent('kq_link:server:dispatch:sendAlert', -1, data)
end)
