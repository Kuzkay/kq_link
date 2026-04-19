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

function NormalizeItemDefinition(name, def)
    def = def or {}

    local image = def.image or def.img
    if not image and def.client and type(def.client) == 'table' then
        image = def.client.image
    end
    if image and not image:find('%.') then
        image = image .. '.png'
    end
    if not image then
        image = name .. '.png'
    end

    local stack = def.stack
    if stack == nil then stack = def.unique == nil or def.unique == false end

    return {
        name = name,
        label = def.label or def.Label or name,
        weight = tonumber(def.weight) or 0,
        stack = stack and true or false,
        description = def.description or def.desc or '',
        image = image,
    }
end

