
-- Custom useful functions
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
