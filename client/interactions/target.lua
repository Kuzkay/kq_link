local SYSTEM = Link.input.target.system

function AddEntityToTargeting(entity, message, event, canInteract, meta, maxDist, icon)
    if not Link.input.target.enabled or not SYSTEM then
        return
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
            end
        }
    }
    
    if SYSTEM == 'ox-target' or SYSTEM == 'ox_target' then
        return exports[SYSTEM]:addLocalEntity(entity, options)
    else
        exports[SYSTEM]:AddTargetEntity(entity, {
            options = options,
            distance = maxDist
        })
        return entity
    end
end

function AddZoneToTargeting(coords, rotation, scale, message, event, canInteract, meta, maxDist, icon)
    if not Link.input.target.enabled or not SYSTEM then
        return
    end
    
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
            rotation = rotation or vector3(0, 0, 0),
            debug = Link.debugMode or false,
            drawSprite = true,
            options = options,
        })
    else
        local identifier = math.random(0, 999999) .. '-' .. GetGameTimer()
        
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

function RemoveTargetZone(identifier)
    if SYSTEM == 'ox-target' or SYSTEM == 'ox_target' then
        exports[SYSTEM]:removeZone(identifier)
    else
        -- Solution for qb-target and qtarget
        exports[SYSTEM]:RemoveZone(identifier)
    end
end

function RemoveTargetEntity(identifier)
    if SYSTEM == 'ox-target' or SYSTEM == 'ox_target' then
        exports[SYSTEM]:removeLocalEntity(identifier)
    else
        -- Solution for qb-target and qtarget
        exports[SYSTEM]:RemoveTargetEntity(identifier)
    end
end
