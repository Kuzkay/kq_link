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

function NormalizeItems(raw)
    local items = {}
    if type(raw) ~= 'table' then return items end

    for name, def in pairs(raw) do
        local key = def.name or name
        local stack = def.stack
        if stack == nil then stack = def.unique == nil or def.unique == false end

        items[key] = {
            name        = key,
            label       = def.label or def.Label or key,
            weight      = tonumber(def.weight) or 0,
            description = def.description or def.desc or '',
            stack       = stack and true or false,
            image       = def.image or def.img,
        }
    end

    return items
end