local SYSTEM = Link.input.target.system

local _qbZoneCache = {}
local _qbEntityCache = {}

local function GetUniqueZoneKeyFromCoords(coords)
    return string.format('%.2f_%.2f_%.2f', coords.x, coords.y, coords.z)
end

function InputUtils.AddEntityToTargeting(entity, message, event, canInteract, meta, maxDist, icon)
    if not Link.input.target.enabled or not SYSTEM then
        return
    end

    if SYSTEM == 'interact' then
        return exports[SYSTEM]:AddLocalEntityInteraction({
            entity = entity,
            id = entity,
            distance = maxDist * 3,
            interactDst = maxDist,
            ignoreLos = false,
            interactDst = maxDist,
            id = entity,
            options = {
                {
                    label = message,
                    canInteract = canInteract,
                    event = event,
                }
            }
        })
    end

    local options = {
        {
            type = 'client',
            event = event,
            icon = icon or 'fas fa-hand',
            label = message,
            targetEntity = entity,
            meta = meta,
            distance = maxDist,
            canInteract = canInteract or function()
                return true
            end,
        }
    }

    if SYSTEM == 'ox-target' or SYSTEM == 'ox_target' then
        return exports[SYSTEM]:addLocalEntity(entity, options)
    elseif SYSTEM == 'qb-target' then
        if not _qbEntityCache[entity] then
            _qbEntityCache[entity] = { maxDist = maxDist, options = {} }
        end

        for _, o in ipairs(_qbEntityCache[entity].options) do
            if o.event == event then return entity end
        end

        table.insert(_qbEntityCache[entity].options, options[1])
        _qbEntityCache[entity].maxDist = math.max(_qbEntityCache[entity].maxDist, maxDist)

        if _qbEntityCache[entity].registered then
            exports[SYSTEM]:RemoveTargetEntity(entity)
        end

        exports[SYSTEM]:AddTargetEntity(entity, {
            options = _qbEntityCache[entity].options,
            distance = _qbEntityCache[entity].maxDist
        })

        _qbEntityCache[entity].registered = true

        return entity
    else
        exports[SYSTEM]:AddTargetEntity(entity, {
            options = options,
            distance = maxDist
        })
        return entity
    end
end

function InputUtils.AddZoneToTargeting(coords, rotation, scale, message, event, canInteract, meta, maxDist, icon)
    if not Link.input.target.enabled or not SYSTEM then
        return
    end

    local identifier = math.random(0, 999999) .. '-' .. GetGameTimer()

    if SYSTEM == 'interact' then
        return exports[SYSTEM]:AddInteraction({
            coords = coords,
            distance = maxDist * 3,
            interactDst = maxDist,
            id = identifier,
            options = {
                {
                    label = message,
                    canInteract = canInteract,
                    event = event,
                }
            }
        })
    end

    -- NON interact system

    local options = {
        {
            type = 'client',
            event = event,
            icon = icon or 'fas fa-hand',
            label = message,
            meta = meta,
            distance = maxDist,
            canInteract = canInteract or function()
                return true
            end
        }
    }

    if SYSTEM == 'ox-target' or SYSTEM == 'ox_target' then
        return exports[SYSTEM]:addBoxZone({
            coords = coords,
            size = scale.yxz,
            rotation = (rotation or vector3(0, 0, 0)).z,
            debug = Link.debugMode or false,
            drawSprite = true,
            options = options,
        })
    elseif SYSTEM == 'qb-target' then
        local key = GetUniqueZoneKeyFromCoords(coords)

        if not _qbZoneCache[key] then
            _qbZoneCache[key] = {
                coords = coords,
                scaleX = scale.x,
                scaleY = scale.y,
                zoneOpts = {
                    name = key,
                    debugPoly = Link.debugMode or false,
                    useZ = true,
                    minZ = coords.z - (scale.z / 2),
                    maxZ = coords.z + (scale.z / 2),
                },
                maxDist = maxDist,
                options = {},
                registered = false,
            }
        end

        for _, o in ipairs(_qbZoneCache[key].options) do
            if o.event == event then return key end
        end

        table.insert(_qbZoneCache[key].options, options[1])
        _qbZoneCache[key].maxDist = math.max(_qbZoneCache[key].maxDist, maxDist)

        if _qbZoneCache[key].registered then
            exports[SYSTEM]:RemoveZone(key)
        end

        local cache = _qbZoneCache[key]
        exports[SYSTEM]:AddBoxZone(key, cache.coords, cache.scaleX, cache.scaleY, cache.zoneOpts, {
            options = cache.options,
            distance = cache.maxDist
        })

        _qbZoneCache[key].registered = true

        return key
    else
        exports[SYSTEM]:AddBoxZone(identifier, coords, scale.x, scale.y, {
            name = identifier,
            debugPoly = Link.debugMode or false,
            useZ = true,
            minZ = coords - (scale.z / 2),
            maxZ = coords + (scale.z / 2),
        }, {
            options = options,
            distance = maxDist
        })

        return identifier
    end
end

function InputUtils.RemoveTargetZone(identifier)
    if not Link.input.target.enabled or not SYSTEM then
        return
    end

    if SYSTEM == 'ox-target' or SYSTEM == 'ox_target' then
        exports[SYSTEM]:removeZone(identifier)
    elseif SYSTEM == 'interact' then
        exports[SYSTEM]:RemoveInteraction(identifier)
    else
        -- Solution for qb-target and qtarget
        exports[SYSTEM]:RemoveZone(identifier)
        _qbZoneCache[identifier] = nil
    end
end

function InputUtils.RemoveTargetZoneOption(coords, event)
    if not Link.input.target.enabled or not SYSTEM or SYSTEM ~= 'qb-target' then
        return
    end

    local key = GetUniqueZoneKeyFromCoords(coords)
    local cache = _qbZoneCache[key]

    if not cache then return end

    for i, o in ipairs(cache.options) do
        if o.event == event then
            table.remove(cache.options, i)
            break
        end
    end

    exports[SYSTEM]:RemoveZone(key)

    if #cache.options > 0 then
        exports[SYSTEM]:AddBoxZone(key, cache.coords, cache.scaleX, cache.scaleY, cache.zoneOpts, {
            options = cache.options,
            distance = cache.maxDist
        })
    else
        _qbZoneCache[key] = nil
    end
end

function InputUtils.RemoveTargetEntity(identifier)
    if not Link.input.target.enabled or not SYSTEM then
        return
    end

    if SYSTEM == 'ox-target' or SYSTEM == 'ox_target' then
        exports[SYSTEM]:removeLocalEntity(identifier)
    elseif SYSTEM == 'interact' then
        exports[SYSTEM]:RemoveLocalEntityInteraction(identifier, identifier)
    else
        -- Solution for qb-target and qtarget
        exports[SYSTEM]:RemoveTargetEntity(identifier)
        _qbEntityCache[identifier] = nil
    end
end

function InputUtils.RemoveTargetEntityOption(entity, event)
    if not Link.input.target.enabled or not SYSTEM or SYSTEM ~= 'qb-target' then
        return
    end

    local cache = _qbEntityCache[entity]

    if not cache then return end

    for i, o in ipairs(cache.options) do
        if o.event == event then
            table.remove(cache.options, i)
            break
        end
    end

    exports[SYSTEM]:RemoveTargetEntity(entity)

    if #cache.options > 0 then
        exports[SYSTEM]:AddTargetEntity(entity, {
            options = cache.options,
            distance = cache.maxDist
        })
    else
        _qbEntityCache[entity] = nil
    end
end
