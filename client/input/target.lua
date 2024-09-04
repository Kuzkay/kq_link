function AddEntityToTargeting(entity, offset, message, event, canInteract, meta, icon)
    if (Link.input.target.enabled and Link.input.target.system) then
        local system = Link.input.target.system
        
        local options = {
            {
                type = 'client',
                event = event,
                icon = icon or 'fas fa-hand',
                label = message,
                targetEntity = entity,
                meta = meta,
                canInteract = canInteract or function () return true end
            }
        }
        
        local sizeMin, sizeMax = GetModelDimensions(GetEntityModel(entity))
        local scale = (sizeMax - sizeMin) + vector3(0.2, 0.2, 0.2)
        local coords = GetOffsetFromEntityInWorldCoords(entity, offset or vector3(0, 0, 0))
        
        if system == 'ox-target' or system == 'ox_target' then
            return exports[system]:addBoxZone({
                coords = coords,
                size = scale.yxz,
                rotation = GetEntityRotation(entity),
                debug = Link.debugMode or false,
                drawSprite = true,
                options = options,
            })
        else
            local identifier = entity .. '-' .. GetGameTimer()
            
            exports[system]:AddBoxZone(identifier, coords, scale.x, scale.y, {
                name = identifier,
                debugPoly = Link.debugMode or false,
                useZ = true,
                minZ = coords + sizeMin.z,
                maxZ = coords + sizeMax.z,
            }, {
                options = options,
                distance = 1.25
            })
            return identifier
        end
    end
end

function RemoveTargetZone(identifier)
    local system = Link.input.target.system
    
    if system == 'ox-target' or system == 'ox_target' then
        exports[system]:removeZone(identifier)
    else
        exports[system]:RemoveZone(identifier)
    end
end
