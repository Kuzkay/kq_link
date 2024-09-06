local PLAYER_INTERACTIONS = {}
local INTERACTION_THREAD_RUNNING = false
local LAST_OUTLINE_ENTITY = nil

function AddInteractionEntity(entity, offset, message, targetMessage, input, callback, canInteract, meta, interactDist, icon)
    return RegisterInteraction({
        entity = entity,
        offset = offset,
        
        message = message,
        targetMessage = targetMessage,
        input = input,
        callback = callback,
        canInteract = canInteract,
        interactDist = interactDist,
        icon = icon,
        
        meta = meta,
    })
end

function AddInteractionZone(coords, rotation, scale, message, targetMessage, input, callback, canInteract, meta, interactDist, icon)
    return RegisterInteraction({
        coords = coords,
        rotation = rotation,
        scale = scale,
        
        message = message,
        targetMessage = targetMessage,
        input = input,
        callback = callback,
        canInteract = canInteract,
        interactDist = interactDist,
        icon = icon,
        
        meta = meta,
    })
end

function RegisterInteraction(data)
    local self = {
        invoker = GetInvokingResource(),
        
        key = GetGameTimer() .. '-' .. math.random(0, 9999999),
        
        entity = data.entity,
        entityOffset = data.offset,
        
        coords = data.coords,
        rotation = data.rotation or vector3(0, 0, 0),
        scale = data.scale,
        
        message = data.message,
        targetMessage = data.targetMessage,
        input = data.input,
        interactDist = data.interactDist or 2,
        
        callback = data.callback,
        canInteract = data.canInteract,
        
        meta = data.meta,
        
        -- Filled later
        targetEntity = nil,
        targetZone = nil,
        
        eventHandler = nil,
    }
    
    -- Booting / Setup
    self.Boot = function()
        if Link.input.target.enabled then
            self.SetupTargetSystem()
            
            return
        end
        
        TriggerInteractionThread()
    end
    
    self.SetupTargetSystem = function()
        local eventKey = GetCurrentResourceName() .. ':target:' .. self.key
        
        RegisterNetEvent(eventKey)
        self.eventHandler = AddEventHandler(eventKey, function()
            self.PerformSafeCallback()
        end)
        
        if self.entity then
            self.targetEntity = AddEntityToTargeting(self.entity, self.targetMessage, eventKey, self.canInteract, self.meta, self.interactDist, self.icon)
        else
            self.targetZone = AddZoneToTargeting(self.coords, self.rotation, self.scale, self.targetMessage, eventKey, self.canInteract, self.meta, self.interactDist, self.icon)
        end
    end
    
    -- Displaying and handling of the input options
    self.Handle = function()
        if not UseCache('canInteract' .. self.key, self.canInteract, 500) then
            return
        end
        
        local coords = self.GetCoords()
        
        local inputType = Link.input.other.inputType
        if inputType == 'top-left' then
            KeybindTip(self.message)
        elseif inputType == 'help-text' then
            DrawFloatingText(coords, self.message)
        elseif inputType == '3d-text' then
            Draw3DText(coords, self.message, 0.042)
        end
        
        if IsControlJustReleased(0, self.input) then
            if self.entity then
                LAST_OUTLINE_ENTITY = nil
                SetEntityDrawOutline(self.entity, false)
            end
            
            self.PerformSafeCallback()
            Citizen.Wait(500) -- Interaction debounce
        end
    end
    
    -- Perform a safe callback with error logging
    self.PerformSafeCallback = function()
        local success, err = pcall(self.callback, self.clientReturnData)
        if not success then
            print(
                ('^1Interactable callback from {resource} has failed.'):gsub('{resource}', self.invoker),
                err
            )
        end
    end
    
    -- Getters
    self.GetMeta = function()
        return self.meta
    end
    
    self.GetInvoker = function()
        return self.invoker
    end
    
    self.GetCoords = function()
        return self.coords or GetOffsetFromEntityInWorldCoords(self.entity, self.entityOffset)
    end
    
    self.GetEntity = function()
        return self.entity
    end
    
    -- Deleting
    
    self.Delete = function()
        if self.eventHandler then
            RemoveEventHandler(self.eventHandler)
        end
        
        -- Targeting cleanup
        if self.targetEntity then
            RemoveTargetEntity(self.targetEntity)
        elseif self.targetZone then
            RemoveTargetZone(self.targetZone)
        end
        
        print('Delete interaction', self.key)
        
        PLAYER_INTERACTIONS[self.key] = nil
        self = nil
    end
    
    --
    
    self.Boot()
    
    -- Add the interaction to the list
    PLAYER_INTERACTIONS[self.key] = self
    
    print('Registered new interactable', json.encode(self.meta), self.GetCoords(), DoesEntityExist(self.entity))
    
    self.clientReturnData = {
        GetMeta = self.GetMeta,
        GetCoords = self.GetCoords,
        GetEntity = self.GetEntity,
        GetInvoker = self.GetInvoker,
        Delete = self.Delete,
    }
    
    return self.clientReturnData
end

function TriggerInteractionThread()
    Citizen.CreateThread(function()
        Citizen.Wait(500
        )
        print('triggering interaction thread')
        -- Only needs to run once for non-target systems
        if INTERACTION_THREAD_RUNNING or Link.input.target.enabled then
            print('aborted', Count(PLAYER_INTERACTIONS))
            return
        end
        
        INTERACTION_THREAD_RUNNING = true
        
        while Count(PLAYER_INTERACTIONS) > 0 do
            local sleep = 2500
            print('thread running')
            
            local interaction, distance = GetClosestPlayerInteraction(5)
            if interaction then
                sleep = 500
            end
            
            if interaction ~= nil and distance < interaction.interactDist then
                sleep = 1
                interaction.Handle()
                
                if interaction.entity then
                    local entity = interaction.entity
                    if Link.input.other.outline.enabled and LAST_OUTLINE_ENTITY ~= interaction.entity then
                        if LAST_OUTLINE_ENTITY ~= nil then
                            SetEntityDrawOutline(LAST_OUTLINE_ENTITY, false)
                        end
                        
                        LAST_OUTLINE_ENTITY = entity
                        
                        SetEntityDrawOutline(entity, true)
                        SetEntityDrawOutlineShader(1)
                        local outlineColor = Link.input.other.outline.color
                        SetEntityDrawOutlineColor(outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a)
                    end
                end
            else
                if LAST_OUTLINE_ENTITY ~= nil then
                    SetEntityDrawOutline(LAST_OUTLINE_ENTITY, false)
                    LAST_OUTLINE_ENTITY = nil
                end
            end
            
            Citizen.Wait(sleep)
        end
        INTERACTION_THREAD_RUNNING = false
        
        if Link.input.other.outline.enabled then
            SetEntityDrawOutline(LAST_OUTLINE_ENTITY, false)
            LAST_OUTLINE_ENTITY = nil
        end
    end)
end

function GetClosestPlayerInteraction(maxDistance)
    return UseCache('GetClosestPlayerInteraction', function()
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        local nearest = nil
        local nearestDistance = maxDistance
        
        for k, playerInteraction in pairs(PLAYER_INTERACTIONS) do
            local coords = playerInteraction.GetCoords()
            
            local distance = #(playerCoords - coords)
            if distance < nearestDistance then
                nearest = playerInteraction
                nearestDistance = distance
            end
        end
        
        return nearest, nearestDistance
    end, 1000)
end

--- CLEANUP
function DeadInteractionRemovalThread()
    Citizen.CreateThread(function()
        while true do
            CleanUpDeadInteractions()
            Citizen.Wait(5000)
        end
    end)
end

function CleanUpDeadInteractions()
    for k, interaction in pairs(PLAYER_INTERACTIONS) do
        if interaction.entity and not DoesEntityExist(interaction.entity) then
            interaction.Delete()
        elseif GetResourceState(interaction.GetInvoker()) ~= 'started' then
            interaction.Delete()
        end
    end
end

DeadInteractionRemovalThread()

AddEventHandler('onResourceStop', function(stoppedResource)
    for k, interaction in pairs(PLAYER_INTERACTIONS) do
        if interaction.GetInvoker() == stoppedResource then
            interaction.Delete()
        end
    end
end)


--- EXPORTS
exports('AddInteractionEntity', AddInteractionEntity)
exports('AddInteractionZone', AddInteractionZone)
