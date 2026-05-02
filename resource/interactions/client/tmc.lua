local SYSTEM = Link.input.target.system
if SYSTEM ~= 'tmc' and SYSTEM ~= 'tmc-core' then return end

local TMC = nil
local _tmcReady = false

local _tmcEntityCache = {}
local _tmcZoneCache = {}
local _tmcVisibleGroups = {}

local _pendingEntities = {}
local _pendingZones = {}

local function GetUniqueZoneKeyFromCoords(coords)
    return string.format('%.2f_%.2f_%.2f', coords.x, coords.y, coords.z)
end

local function CreateTMCPrompt(message, event, canInteract, icon)
    return {
        Id = event,
        Title = message,
        Icon = icon or 'fas fa-hand',
        Complete = function()
            if canInteract and not canInteract() then return end
            TriggerEvent(event)
        end
    }
end

local function RegisterEntityPrompt(entity, message, event, canInteract, meta, maxDist, icon)
    local prompt = CreateTMCPrompt(message, event, canInteract, icon)
    local groupId = TMC.Functions.CreatePromptGroup({ prompt })

    _tmcEntityCache[entity] = {
        groupId = groupId,
        maxDist = maxDist or 2.0,
        canInteract = canInteract,
        prompts = { prompt }
    }
end

local function RegisterZonePrompt(identifier, coords, scale, message, event, canInteract, meta, maxDist, icon)
    local prompt = CreateTMCPrompt(message, event, canInteract, icon)
    local groupId = TMC.Functions.CreatePromptGroup({ prompt })

    _tmcZoneCache[identifier] = {
        groupId = groupId,
        coords = coords,
        scale = scale or vector3(2.0, 2.0, 2.0),
        maxDist = maxDist or 2.0,
        canInteract = canInteract,
        prompts = { prompt }
    }
end

function InputUtils.AddEntityToTargeting(entity, message, event, canInteract, meta, maxDist, icon)
    if not Link.input.target.enabled or not SYSTEM then return end

    if not _tmcReady then
        table.insert(_pendingEntities, {entity, message, event, canInteract, meta, maxDist, icon})
        return entity
    end

    RegisterEntityPrompt(entity, message, event, canInteract, meta, maxDist, icon)
    return entity
end

function InputUtils.AddZoneToTargeting(coords, rotation, scale, message, event, canInteract, meta, maxDist, icon)
    if not Link.input.target.enabled or not SYSTEM then return end

    local identifier = GetUniqueZoneKeyFromCoords(coords)

    if not _tmcReady then
        table.insert(_pendingZones, {identifier, coords, scale, message, event, canInteract, meta, maxDist, icon})
        return identifier
    end

    RegisterZonePrompt(identifier, coords, scale, message, event, canInteract, meta, maxDist, icon)
    return identifier
end

function InputUtils.RemoveTargetEntity(entity)
    if not Link.input.target.enabled or not SYSTEM then return end

    local cache = _tmcEntityCache[entity]
    if cache and _tmcReady then
        TMC.Functions.DeletePromptGroup(cache.groupId)
    end
    _tmcEntityCache[entity] = nil
    _tmcVisibleGroups[entity] = nil
end

function InputUtils.RemoveTargetZone(identifier)
    if not Link.input.target.enabled or not SYSTEM then return end

    local cache = _tmcZoneCache[identifier]
    if cache and _tmcReady then
        TMC.Functions.DeletePromptGroup(cache.groupId)
    end
    _tmcZoneCache[identifier] = nil
    _tmcVisibleGroups[identifier] = nil
end

function InputUtils.RemoveTargetEntityOption(entity, event)
    if not Link.input.target.enabled or not SYSTEM or not _tmcReady then return end

    local cache = _tmcEntityCache[entity]
    if not cache then return end

    for i, p in ipairs(cache.prompts) do
        if p.Id == event then
            table.remove(cache.prompts, i)
            break
        end
    end

    TMC.Functions.DeletePromptGroup(cache.groupId)

    if #cache.prompts > 0 then
        cache.groupId = TMC.Functions.CreatePromptGroup(cache.prompts)
    else
        _tmcEntityCache[entity] = nil
        _tmcVisibleGroups[entity] = nil
    end
end

function InputUtils.RemoveTargetZoneOption(coords, event)
    if not Link.input.target.enabled or not SYSTEM or not _tmcReady then return end

    local key = GetUniqueZoneKeyFromCoords(coords)
    local cache = _tmcZoneCache[key]
    if not cache then return end

    for i, p in ipairs(cache.prompts) do
        if p.Id == event then
            table.remove(cache.prompts, i)
            break
        end
    end

    TMC.Functions.DeletePromptGroup(cache.groupId)

    if #cache.prompts > 0 then
        cache.groupId = TMC.Functions.CreatePromptGroup(cache.prompts)
    else
        _tmcZoneCache[key] = nil
        _tmcVisibleGroups[key] = nil
    end
end

local function IsPointInBox(point, center, scale)
    if not scale then return false end
    local half = scale / 2
    return point.x >= center.x - half.x and point.x <= center.x + half.x
       and point.y >= center.y - half.y and point.y <= center.y + half.y
       and point.z >= center.z - half.z and point.z <= center.z + half.z
end

CreateThread(function()
    Wait(1000)
    TMC = exports.core:getCoreObject()
    _tmcReady = true

    for _, pending in ipairs(_pendingEntities) do
        RegisterEntityPrompt(pending[1], pending[2], pending[3], pending[4], pending[5], pending[6], pending[7])
    end
    _pendingEntities = {}

    for _, pending in ipairs(_pendingZones) do
        RegisterZonePrompt(pending[1], pending[2], pending[3], pending[4], pending[5], pending[6], pending[7], pending[8], pending[9])
    end
    _pendingZones = {}

    while true do
        Wait(250)
        local playerCoords = GetEntityCoords(PlayerPedId())

        for entity, cache in pairs(_tmcEntityCache) do
            if DoesEntityExist(entity) then
                local entityCoords = GetEntityCoords(entity)
                local dist = #(playerCoords - entityCoords)
                local inRange = dist <= cache.maxDist
                local canShow = not cache.canInteract or cache.canInteract()

                if inRange and canShow and not _tmcVisibleGroups[entity] then
                    TMC.Functions.ShowPromptGroup(cache.groupId)
                    _tmcVisibleGroups[entity] = true
                elseif (not inRange or not canShow) and _tmcVisibleGroups[entity] then
                    TMC.Functions.HidePromptGroup(cache.groupId)
                    _tmcVisibleGroups[entity] = nil
                end
            else
                if _tmcVisibleGroups[entity] then
                    TMC.Functions.HidePromptGroup(cache.groupId)
                end
                TMC.Functions.DeletePromptGroup(cache.groupId)
                _tmcEntityCache[entity] = nil
                _tmcVisibleGroups[entity] = nil
            end
        end

        for key, cache in pairs(_tmcZoneCache) do
            local dist = #(playerCoords - cache.coords)
            local inZone = dist <= cache.maxDist or IsPointInBox(playerCoords, cache.coords, cache.scale)
            local canShow = not cache.canInteract or cache.canInteract()

            if inZone and canShow and not _tmcVisibleGroups[key] then
                TMC.Functions.ShowPromptGroup(cache.groupId)
                _tmcVisibleGroups[key] = true
            elseif (not inZone or not canShow) and _tmcVisibleGroups[key] then
                TMC.Functions.HidePromptGroup(cache.groupId)
                _tmcVisibleGroups[key] = nil
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() or not _tmcReady then return end

    for entity, cache in pairs(_tmcEntityCache) do
        TMC.Functions.DeletePromptGroup(cache.groupId)
    end
    for key, cache in pairs(_tmcZoneCache) do
        TMC.Functions.DeletePromptGroup(cache.groupId)
    end
end)
