function NormalizeInventoryOutput(inventory_output)
    local normalized_output = {}

    if type(inventory_output) ~= 'table' then
        return normalized_output
    end

    if type(inventory_output.items) == 'table' then
        inventory_output = inventory_output.items
    end

    for pos, item in pairs(inventory_output) do
        if type(item) == 'table' then
            item.label = item.label or item.name
            item.count = item.count or item.amount
            item.meta = item.meta or item.metadata or item.info

            normalized_output[pos] = item
        end
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
