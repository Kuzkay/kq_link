local SYSTEM = Link.input.target.system
if SYSTEM ~= 'tmc' and SYSTEM ~= 'tmc-core' then return end

local TMC = nil
local _tmcReady = false

local _entityInteractions = {}
local _zoneInteractions = {}

local _activeGroupId = nil
local _lastPromptIds = {}

CreateThread(function()
    Citizen.Wait(1000)
    TMC = exports.core:getCoreObject()
    _tmcReady = true
end)

local function WaitForTMC()
    while not _tmcReady do Citizen.Wait(100) end
end

local function GetZoneKey(coords)
    return string.format('%.2f_%.2f_%.2f', coords.x, coords.y, coords.z)
end

local function GetValidPrompts(playerCoords)
    local prompts = {}
    local promptIds = {}

    for entity, interactions in pairs(_entityInteractions) do
        if DoesEntityExist(entity) then
            local entityCoords = GetEntityCoords(entity)
            local dist = #(playerCoords - entityCoords)

            for _, interaction in ipairs(interactions) do
                local maxDist = (interaction.maxDist or 2.0) + Link.input.target.tmcDistance
                if dist <= maxDist then
                    if not interaction.canInteract or interaction.canInteract() then
                        table.insert(prompts, {
                            Id = interaction.event,
                            Title = interaction.message,
                            Icon = interaction.icon or 'fas fa-hand',
                            Complete = function()
                                if interaction.canInteract and not interaction.canInteract() then return end
                                TriggerEvent(interaction.event)
                            end
                        })
                        promptIds[interaction.event] = true
                    end
                end
            end
        end
    end

    for key, zoneData in pairs(_zoneInteractions) do
        local dist = #(playerCoords - zoneData.coords)

        for _, interaction in ipairs(zoneData.interactions) do
            local maxDist = interaction.maxDist or zoneData.maxDist or 2.0
            if dist <= maxDist then
                if not interaction.canInteract or interaction.canInteract() then
                    table.insert(prompts, {
                        Id = interaction.event,
                        Title = interaction.message,
                        Icon = interaction.icon or 'fas fa-hand',
                        Complete = function()
                            if interaction.canInteract and not interaction.canInteract() then return end
                            TriggerEvent(interaction.event)
                        end
                    })
                    promptIds[interaction.event] = true
                end
            end
        end
    end

    return prompts, promptIds
end

local function PromptsChanged(newPromptIds)
    for id in pairs(newPromptIds) do
        if not _lastPromptIds[id] then return true end
    end
    for id in pairs(_lastPromptIds) do
        if not newPromptIds[id] then return true end
    end
    return false
end

function InputUtils.AddEntityToTargeting(entity, message, event, canInteract, meta, maxDist, icon)
    if not Link.input.target.enabled or not SYSTEM then return end

    if not _entityInteractions[entity] then
        _entityInteractions[entity] = {}
    end

    for _, interaction in ipairs(_entityInteractions[entity]) do
        if interaction.event == event then
            return entity
        end
    end

    table.insert(_entityInteractions[entity], {
        message = message,
        event = event,
        canInteract = canInteract,
        icon = icon,
        maxDist = maxDist or 2.0
    })

    return entity
end

function InputUtils.AddZoneToTargeting(coords, rotation, scale, message, event, canInteract, meta, maxDist, icon)
    if not Link.input.target.enabled or not SYSTEM then return end

    local key = GetZoneKey(coords)

    if not _zoneInteractions[key] then
        _zoneInteractions[key] = {
            coords = coords,
            maxDist = maxDist or 2.0,
            interactions = {}
        }
    end

    for _, interaction in ipairs(_zoneInteractions[key].interactions) do
        if interaction.event == event then
            return key
        end
    end

    table.insert(_zoneInteractions[key].interactions, {
        message = message,
        event = event,
        canInteract = canInteract,
        icon = icon,
        maxDist = maxDist
    })

    if maxDist and maxDist > _zoneInteractions[key].maxDist then
        _zoneInteractions[key].maxDist = maxDist
    end

    return key
end

function InputUtils.RemoveTargetEntity(entity)
    if not Link.input.target.enabled or not SYSTEM then return end
    _entityInteractions[entity] = nil
end

function InputUtils.RemoveTargetZone(identifier)
    if not Link.input.target.enabled or not SYSTEM then return end
    _zoneInteractions[identifier] = nil
end

function InputUtils.RemoveTargetEntityOption(entity, event)
    if not Link.input.target.enabled or not SYSTEM then return end

    local interactions = _entityInteractions[entity]
    if not interactions then return end

    for i, interaction in ipairs(interactions) do
        if interaction.event == event then
            table.remove(interactions, i)
            break
        end
    end

    if #interactions == 0 then
        _entityInteractions[entity] = nil
    end
end

function InputUtils.RemoveTargetZoneOption(coords, event)
    if not Link.input.target.enabled or not SYSTEM then return end

    local key = GetZoneKey(coords)
    local zoneData = _zoneInteractions[key]
    if not zoneData then return end

    for i, interaction in ipairs(zoneData.interactions) do
        if interaction.event == event then
            table.remove(zoneData.interactions, i)
            break
        end
    end

    if #zoneData.interactions == 0 then
        _zoneInteractions[key] = nil
    end
end

CreateThread(function()
    WaitForTMC()

    while true do
        Citizen.Wait(250)

        local playerCoords = GetEntityCoords(PlayerPedId())
        local prompts, promptIds = GetValidPrompts(playerCoords)

        if #prompts > 0 then
            if PromptsChanged(promptIds) then
                if _activeGroupId then
                    TMC.Functions.DeletePromptGroup(_activeGroupId)
                end
                _activeGroupId = TMC.Functions.CreatePromptGroup(prompts)
                if _activeGroupId then
                    TMC.Functions.ShowPromptGroup(_activeGroupId)
                end
                _lastPromptIds = promptIds
            end
        else
            if _activeGroupId then
                TMC.Functions.DeletePromptGroup(_activeGroupId)
                _activeGroupId = nil
                _lastPromptIds = {}
            end
        end

        for entity in pairs(_entityInteractions) do
            if not DoesEntityExist(entity) then
                _entityInteractions[entity] = nil
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() or not _tmcReady then return end

    if _activeGroupId then
        TMC.Functions.DeletePromptGroup(_activeGroupId)
    end
end)
