local SYSTEM = Link.input.target.system
if SYSTEM ~= 'tmc' and SYSTEM ~= 'tmc-core' then return end

local TMC = nil
local _tmcReady = false

local _tmcEntityCache = {}
local _tmcZoneCache = {}
local _tmcVisibleGroups = {}

CreateThread(function()
    Debug('[TMC] Waiting for TMC core...')
    Wait(1000)
    TMC = exports.core:getCoreObject()
    _tmcReady = true
    Debug('[TMC] Core ready')
end)

local function WaitForTMC()
    while not _tmcReady do Wait(100) end
end

local function GetUniqueZoneKeyFromCoords(coords)
    return string.format('%.2f_%.2f_%.2f', coords.x, coords.y, coords.z)
end

local function CreateTMCPrompt(message, event, canInteract, icon)
    return {
        Id = event,
        Title = message,
        Icon = icon or 'fas fa-hand',
        canInteract = canInteract,
        Complete = function()
            Debug('[TMC] Prompt completed:', event)
            if canInteract and not canInteract() then
                Debug('[TMC] canInteract failed for:', event)
                return
            end
            TriggerEvent(event)
        end
    }
end

local function CanShowAnyPrompt(prompts)
    for _, prompt in ipairs(prompts) do
        if not prompt.canInteract or prompt.canInteract() then
            return true
        end
    end
    return false
end

local function RebuildEntityPromptGroup(entity)
    local cache = _tmcEntityCache[entity]
    if not cache or #cache.prompts == 0 then return end

    if cache.groupId then
        TMC.Functions.DeletePromptGroup(cache.groupId)
    end
    cache.groupId = TMC.Functions.CreatePromptGroup(cache.prompts)
end

local function RebuildZonePromptGroup(identifier)
    local cache = _tmcZoneCache[identifier]
    if not cache or #cache.prompts == 0 then return end

    if cache.groupId then
        TMC.Functions.DeletePromptGroup(cache.groupId)
    end
    cache.groupId = TMC.Functions.CreatePromptGroup(cache.prompts)
end

function InputUtils.AddEntityToTargeting(entity, message, event, canInteract, meta, maxDist, icon)
    if not Link.input.target.enabled or not SYSTEM then return end

    Debug('[TMC] AddEntityToTargeting called:', entity, message, maxDist)

    CreateThread(function()
        WaitForTMC()

        local prompt = CreateTMCPrompt(message, event, canInteract, icon)

        if _tmcEntityCache[entity] then
            for _, p in ipairs(_tmcEntityCache[entity].prompts) do
                if p.Id == event then
                    Debug('[TMC] Duplicate event for entity, skipping:', event)
                    return
                end
            end
            table.insert(_tmcEntityCache[entity].prompts, prompt)
            _tmcEntityCache[entity].maxDist = math.max(_tmcEntityCache[entity].maxDist, maxDist or 2.0)
            RebuildEntityPromptGroup(entity)
            Debug('[TMC] Added prompt to existing entity cache:', entity, 'total prompts:', #_tmcEntityCache[entity].prompts)
        else
            local groupId = TMC.Functions.CreatePromptGroup({ prompt })
            Debug('[TMC] Entity prompt group created:', groupId, 'for entity:', entity)

            _tmcEntityCache[entity] = {
                groupId = groupId,
                maxDist = maxDist or 2.0,
                prompts = { prompt }
            }
        end
    end)

    return entity
end

function InputUtils.AddZoneToTargeting(coords, rotation, scale, message, event, canInteract, meta, maxDist, icon)
    if not Link.input.target.enabled or not SYSTEM then return end

    local identifier = GetUniqueZoneKeyFromCoords(coords)

    Debug('[TMC] AddZoneToTargeting called:', identifier, message, 'maxDist:', maxDist)

    CreateThread(function()
        WaitForTMC()

        local prompt = CreateTMCPrompt(message, event, canInteract, icon)

        if _tmcZoneCache[identifier] then
            for _, p in ipairs(_tmcZoneCache[identifier].prompts) do
                if p.Id == event then
                    Debug('[TMC] Duplicate event for zone, skipping:', event)
                    return
                end
            end
            table.insert(_tmcZoneCache[identifier].prompts, prompt)
            _tmcZoneCache[identifier].maxDist = math.max(_tmcZoneCache[identifier].maxDist, maxDist or 2.0)
            RebuildZonePromptGroup(identifier)
            Debug('[TMC] Added prompt to existing zone cache:', identifier, 'total prompts:', #_tmcZoneCache[identifier].prompts)
        else
            local groupId = TMC.Functions.CreatePromptGroup({ prompt })
            Debug('[TMC] Zone prompt group created:', groupId, 'identifier:', identifier, 'maxDist:', maxDist)

            _tmcZoneCache[identifier] = {
                groupId = groupId,
                coords = coords,
                maxDist = maxDist or 2.0,
                prompts = { prompt }
            }
        end
    end)

    return identifier
end

function InputUtils.RemoveTargetEntity(entity)
    if not Link.input.target.enabled or not SYSTEM then return end

    Debug('[TMC] RemoveTargetEntity:', entity)

    local cache = _tmcEntityCache[entity]
    if cache and _tmcReady then
        TMC.Functions.DeletePromptGroup(cache.groupId)
    end
    _tmcEntityCache[entity] = nil
    _tmcVisibleGroups[entity] = nil
end

function InputUtils.RemoveTargetZone(identifier)
    if not Link.input.target.enabled or not SYSTEM then return end

    Debug('[TMC] RemoveTargetZone:', identifier)

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
            Debug('[TMC] Removed prompt from entity:', entity, 'remaining:', #cache.prompts)
            break
        end
    end

    if #cache.prompts > 0 then
        RebuildEntityPromptGroup(entity)
    else
        TMC.Functions.DeletePromptGroup(cache.groupId)
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
            Debug('[TMC] Removed prompt from zone:', key, 'remaining:', #cache.prompts)
            break
        end
    end

    if #cache.prompts > 0 then
        RebuildZonePromptGroup(key)
    else
        TMC.Functions.DeletePromptGroup(cache.groupId)
        _tmcZoneCache[key] = nil
        _tmcVisibleGroups[key] = nil
    end
end

CreateThread(function()
    WaitForTMC()

    Debug('[TMC] Visibility thread started')

    while true do
        Wait(250)
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped)

        local entitiesToRemove = {}

        for entity, cache in pairs(_tmcEntityCache) do
            if DoesEntityExist(entity) then
                local entityCoords = GetEntityCoords(entity)
                local dist = #(playerCoords - entityCoords)
                local inRange = dist <= cache.maxDist
                local canShow = inRange and CanShowAnyPrompt(cache.prompts)

                if canShow then
                    if not _tmcVisibleGroups[entity] then
                        Debug('[TMC] Show entity prompt:', entity, 'dist:', dist, 'maxDist:', cache.maxDist, 'prompts:', #cache.prompts)
                        TMC.Functions.ShowPromptGroup(cache.groupId)
                        _tmcVisibleGroups[entity] = true
                    end
                else
                    if _tmcVisibleGroups[entity] then
                        Debug('[TMC] Hide entity prompt:', entity, 'dist:', dist, 'inRange:', inRange)
                        TMC.Functions.HidePromptGroup(cache.groupId)
                        _tmcVisibleGroups[entity] = nil
                    end
                end
            else
                table.insert(entitiesToRemove, entity)
            end
        end

        for _, entity in ipairs(entitiesToRemove) do
            local cache = _tmcEntityCache[entity]
            if cache then
                Debug('[TMC] Entity no longer exists, cleaning up:', entity)
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
            local inRange = dist <= cache.maxDist
            local canShow = inRange and CanShowAnyPrompt(cache.prompts)

            if canShow then
                if not _tmcVisibleGroups[key] then
                    Debug('[TMC] Show zone prompt:', key, 'dist:', dist, 'maxDist:', cache.maxDist, 'prompts:', #cache.prompts)
                    TMC.Functions.ShowPromptGroup(cache.groupId)
                    _tmcVisibleGroups[key] = true
                end
            else
                if _tmcVisibleGroups[key] then
                    Debug('[TMC] Hide zone prompt:', key, 'dist:', dist, 'inRange:', inRange)
                    TMC.Functions.HidePromptGroup(cache.groupId)
                    _tmcVisibleGroups[key] = nil
                end
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() or not _tmcReady then return end

    Debug('[TMC] Resource stopping, cleaning up prompts')

    for entity, cache in pairs(_tmcEntityCache) do
        TMC.Functions.DeletePromptGroup(cache.groupId)
    end
    for key, cache in pairs(_tmcZoneCache) do
        TMC.Functions.DeletePromptGroup(cache.groupId)
    end
end)
