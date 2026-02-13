function NormalizeInventoryOutput(inventory_output)
    local normalized_output = {}

    for pos, item in pairs(inventory_output) do
        item.label = item.label or item.name
        item.count = item.count or item.amount
        item.meta = item.meta or item.metadata
        
        normalized_output[pos] = item
    end

    return normalized_output
end