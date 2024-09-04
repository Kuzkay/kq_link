local INPUT_ENTITIES = {}
local INPUT_THREAD_RUNNING = false
local LAST_NEAREST = nil
local TARGETS = {}

function AddEntityInput(entity, offset, message, targetMessage, input, callback, canInteract, meta, icon)
    if Link.input.target.enabled then
        local eventKey = GetCurrentResourceName() .. ':target:' .. entity .. '-' .. GetGameTimer()
        
        RegisterNetEvent(eventKey)
        AddEventHandler(eventKey, function(data)
            if DoesEntityExist(data.targetEntity) then
                callback(data.targetEntity, data.meta)
            end
        end)
        
        TARGETS[entity] = AddEntityToTargeting(entity, offset, targetMessage, eventKey, canInteract, meta, icon)
        FreezeEntityPosition(entity, true)
        
        if Count(TARGETS) == 1 then
            TargetCleanupThread()
        end
        
        return
    end
    
    -- Non target
    local inputEntity = {
        entity = entity,
        
        offset = offset,
        message = message,
        input = input,
        callback = callback,
        canInteract = canInteract
    }
    
    INPUT_ENTITIES[entity] = inputEntity
    
    TriggerInputThread()
end

function TargetCleanupThread()
    Citizen.CreateThread(function()
        while Count(TARGETS) > 0 do
            Citizen.Wait(5000)
            for entity, _ in pairs(TARGETS) do
                if not DoesEntityExist(entity) then
                    DeleteEntityInput(entity)
                end
            end
        end
    end)
end

function DeleteEntityInput(entity)
    if Link.input.target.enabled and TARGETS[entity] then
        RemoveTargetZone(TARGETS[entity])
    end
    TARGETS[entity] = nil
    INPUT_ENTITIES[entity] = nil
end

function TriggerInputThread()
    if INPUT_THREAD_RUNNING then
        return
    end
    
    Citizen.CreateThread(function()
        INPUT_THREAD_RUNNING = true
        
        while Count(INPUT_ENTITIES) > 0 do
            local sleep = 2500
            
            local nearestEntity, nearDistance = GetClosestInputEntity(5)
            if nearestEntity then
                sleep = 500
            end
            
            if nearestEntity ~= nil and nearDistance < 1.5 then
                sleep = 1
                HandleEntityInput(nearestEntity)
                
                if Link.input.other.outline.enabled and LAST_NEAREST ~= nearestEntity.entity then
                    if LAST_NEAREST ~= nil then
                        SetEntityDrawOutline(LAST_NEAREST, false)
                    end
                    
                    LAST_NEAREST = nearestEntity.entity
                    SetEntityDrawOutline(nearestEntity.entity, true)
                    SetEntityDrawOutlineShader(1)
                    local outlineColor = Link.input.other.outline.color
                    SetEntityDrawOutlineColor(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a)
                end
            else
                if LAST_NEAREST ~= nil then
                    SetEntityDrawOutline(LAST_NEAREST, false)
                    LAST_NEAREST = nil
                end
            end
            
            Citizen.Wait(sleep)
        end
        
        if Link.input.other.outline.enabled then
            SetEntityDrawOutline(LAST_NEAREST, false)
            LAST_NEAREST = nil
        end
        
        INPUT_THREAD_RUNNING = false
    end)
end

function GetClosestInputEntity(maxDistance)
    return UseCache('GetClosestInputEntity', function()
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        local nearest = nil
        local nearestDistance = maxDistance
        
        for k, inputEntity in pairs(INPUT_ENTITIES) do
            local coords = inputEntity.coords or GetEntityCoords(inputEntity.entity)
            local distance = #(playerCoords - coords)
            if distance < nearestDistance then
                nearest = inputEntity
                nearestDistance = distance
            end
        end
        
        return nearest, nearestDistance
    end, 1000)
end

function HandleEntityInput(inputEntity)
    if not UseCache('canInteract' .. inputEntity.entity, inputEntity.canInteract, 500) then
        return
    end
    
    local coords = (inputEntity.coords or GetEntityCoords(inputEntity.entity)) + GetOffsetFromEntityInWorldCoords(inputEntity.entity, (inputEntity.offset or vector3(0, 0, 0)))
    
    local inputType = Link.input.other.inputType
    if inputType == 'top-left' then
        KeybindTip(inputEntity.message)
    elseif inputType == 'help-text' then
        DrawFloatingText(coords, inputEntity.message)
    elseif inputType == '3d-text' then
        Draw3DText(coords, inputEntity.message, 0.042)
    end
    
    if IsControlJustReleased(0, inputEntity.input) then
        inputEntity.callback(inputEntity.entity, inputEntity.meta)
    end
end




exports('AddEntityInput', AddEntityInput)
