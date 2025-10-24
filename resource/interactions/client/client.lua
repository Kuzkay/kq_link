local PLAYER_INTERACTIONS = {}
local INTERACTION_THREAD_RUNNING = false
local LAST_OUTLINE_ENTITY = nil

local CURRENT_INTERACTION_INDEX = 1
local NEARBY_INTERACTIONS = {}
local LAST_SCROLL_TIME = 0
local SCROLL_DEBOUNCE = 150

local PLAYER_BUSY = false

-- HELPER FUNCTIONS
local function GetNearbyPlayerInteractions()
    return UseCache('GetNearbyPlayerInteractions', function()
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        local nearbyInteractions = {}
        for k, playerInteraction in pairs(PLAYER_INTERACTIONS) do
            local coords = playerInteraction.GetCoords()

            local dx = playerCoords.x - coords.x
            local dy = playerCoords.y - coords.y
            local dz = playerCoords.z - coords.z
            local distanceSq = dx * dx + dy * dy + dz * dz

            local interactDist = playerInteraction.interactDist or 2
            local interactDistSq = interactDist * interactDist

            if distanceSq <= interactDistSq then
                if playerInteraction.SafeCanInteract() then
                    table.insert(nearbyInteractions, {
                        interaction = playerInteraction,
                        distance = math.sqrt(distanceSq), -- Only calculate actual distance when needed
                        coords = coords,
                        key = k
                    })
                end
            end
        end

        table.sort(nearbyInteractions, function(a, b)
            if math.abs(a.distance - b.distance) < 0.25 then
                return tostring(a.key) < tostring(b.key)
            else
                return a.distance < b.distance
            end
        end)

        if #nearbyInteractions > 1 then
            local nearestCoords = nearbyInteractions[1].coords
            local filteredInteractions = {}

            table.insert(filteredInteractions, nearbyInteractions[1])

            local hasCloseInteractions = false
            for i = 2, #nearbyInteractions do
                local distanceToNearest = #(nearbyInteractions[i].coords - nearestCoords)
                if distanceToNearest <= 0.25 then
                    table.insert(filteredInteractions, nearbyInteractions[i])
                    hasCloseInteractions = true
                end
            end

            if hasCloseInteractions then
                return filteredInteractions
            else
                return { nearbyInteractions[1] }
            end
        end

        return nearbyInteractions
    end, 250)
end

local function HandleScrollInput()
    local currentTime = GetGameTimer()

    if currentTime - LAST_SCROLL_TIME < SCROLL_DEBOUNCE then
        return
    end

    local scrollUp = IsControlJustPressed(0, 14) or IsDisabledControlJustPressed(0, 14)
        or IsControlJustPressed(0, 173) or IsDisabledControlJustPressed(0, 173)
    local scrollDown = IsControlJustPressed(0, 15) or IsDisabledControlJustPressed(0, 15)
        or IsControlJustPressed(0, 172) or IsDisabledControlJustPressed(0, 172)

    if scrollUp or scrollDown then
        if #NEARBY_INTERACTIONS > 1 then
            LAST_SCROLL_TIME = currentTime

            if scrollDown then
                CURRENT_INTERACTION_INDEX = CURRENT_INTERACTION_INDEX - 1
                if CURRENT_INTERACTION_INDEX < 1 then
                    CURRENT_INTERACTION_INDEX = #NEARBY_INTERACTIONS
                end
            elseif scrollUp then
                CURRENT_INTERACTION_INDEX = CURRENT_INTERACTION_INDEX + 1
                if CURRENT_INTERACTION_INDEX > #NEARBY_INTERACTIONS then
                    CURRENT_INTERACTION_INDEX = 1
                end
            end
        end
    end
end

local function GetCurrentSelectedInteraction()
    if #NEARBY_INTERACTIONS == 0 then
        return nil
    end

    if CURRENT_INTERACTION_INDEX > #NEARBY_INTERACTIONS then
        CURRENT_INTERACTION_INDEX = 1
    end

    return NEARBY_INTERACTIONS[CURRENT_INTERACTION_INDEX]
end

local function Display3DTextWithOptions(coords, interactions, selectedIndex)
    local spacing = 0.10

    for i, interactionData in ipairs(interactions) do
        local interaction = interactionData.interaction
        local yOffset = (i - selectedIndex) * spacing
        local adjustedCoords = vector3(coords.x, coords.y, coords.z + yOffset)

        if i == selectedIndex then
            InputUtils.Draw3DText(adjustedCoords, interaction.message, 0.042)
        else
            InputUtils.Draw3DText(adjustedCoords, interaction.message, 0.025)
        end
    end

    if #interactions > 1 then
        local hintCoords = vector3(coords.x, coords.y, coords.z - (#interactions * spacing * 0.5) - 0.1)
        InputUtils.Draw3DText(hintCoords, "~w~Scroll (~y~" .. selectedIndex .. "/" .. #interactions .. "~w~)", 0.02)
    end
end

local function DrawKQRect(x, y, w, h, r, g, b, a)
    DrawRect(x + w * 0.5, y + h * 0.5, w, h, r, g, b, math.floor(a))
end

local function DrawKQText(x, y, text, scale, r, g, b, a, centered, outline)
    SetTextFont(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, math.floor(a))
    SetTextCentre(centered or false)
    if outline then
        SetTextDropshadow(1, 0, 0, 0, 50)
        SetTextOutline()
    end
    SetTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawText(x, y)
end

local function DisplayKQInteract(interactions, selectedIndex, coords)
    local onScreen, sx, sy = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    if not onScreen then return end

    local keybindWidth = 0.018
    local keybindHeight = 0.028
    local lineHeight = 0.028
    local mainTextScale = 0.22
    local altTextScale = 0.18

    local keybindBgColor = { r = 0, g = 0, b = 0, a = 150 }
    local keybindTextColor = { r = 255, g = 255, b = 255, a = 255 }
    local mainTextColor = { r = 255, g = 255, b = 255, a = 255 }
    local altTextColor = { r = 180, g = 180, b = 180, a = 200 }
    local selectedBgColor = { r = 0, g = 0, b = 0, a = 200 }

    local totalHeight = #interactions * lineHeight
    local startY = sy - (totalHeight * 0.5)

    local maxTextWidth = 0
    for i, interactionData in ipairs(interactions) do
        local interaction = interactionData.interaction
        local cleanMessage = interaction.targetMessage
        local textWidth = (#cleanMessage * 0.0033) + 0.003
        if textWidth > maxTextWidth then
            maxTextWidth = textWidth
        end
    end

    local totalWidth = keybindWidth + maxTextWidth
    local startX = sx - (totalWidth * 0.5)

    for i, interactionData in ipairs(interactions) do
        local interaction = interactionData.interaction
        local yPos = startY + ((i - 1) * lineHeight)
        local isSelected = (i == selectedIndex)

        if isSelected then
            -- Draw background highlight for selected item
            DrawKQRect(startX, yPos - keybindHeight * 0.5, totalWidth + 0.01, keybindHeight,
                selectedBgColor.r, selectedBgColor.g, selectedBgColor.b, selectedBgColor.a)

            local color = { r = 255, g = 255, b = 255, a = 30 }
            if IsControlPressed(0, 38) then
                color = { r = 108, g = 240, b = 156, a = 160 }
            end
            -- Draw keybind square for selected interaction
            DrawKQRect(startX + 0.002, (yPos - keybindHeight * 0.5) + 0.003, keybindWidth - 0.0055,
                keybindHeight - 0.0055,
                color.r, color.g, color.b, color.a)

            -- Draw keybind text [E]
            local keybindX = (startX + keybindWidth * 0.5) - 0.001
            local keybindY = yPos - 0.008
            local keyButton = GetControlInstructionalButton(0, interaction.input, true)
            local keyLabel = keyButton:sub(3,3)

            DrawKQText(keybindX, keybindY, keyLabel, 0.2, keybindTextColor.r, keybindTextColor.g,
                keybindTextColor.b, keybindTextColor.a, true, false)

            -- Draw main interaction text with brackets
            local textX = startX + keybindWidth
            local textY = yPos - 0.008
            local cleanMessage = interaction.targetMessage
            DrawKQText(textX, textY, cleanMessage, mainTextScale,
                mainTextColor.r, mainTextColor.g, mainTextColor.b, mainTextColor.a, false, false)
        else
            -- Draw alternative interaction
            DrawKQRect(startX, yPos - keybindHeight * 0.5, totalWidth + 0.01, keybindHeight,
                keybindBgColor.r, keybindBgColor.g, keybindBgColor.b, keybindBgColor.a)

            local textX = startX + keybindWidth
            local textY = yPos - 0.008
            local cleanMessage = interaction.targetMessage
            DrawKQText(textX, textY, cleanMessage, altTextScale,
                altTextColor.r, altTextColor.g, altTextColor.b, altTextColor.a, false, false)
        end
    end
end

local function CleanUpDeadInteractions()
    for k, interaction in pairs(PLAYER_INTERACTIONS) do
        if interaction.entity and not DoesEntityExist(interaction.entity) then
            interaction.Delete()
        elseif GetResourceState(interaction.GetInvoker()) ~= 'started' then
            interaction.Delete()
        end
    end
end

local function DeadInteractionRemovalThread()
    Citizen.CreateThread(function()
        while true do
            CleanUpDeadInteractions()
            Citizen.Wait(5000)
        end
    end)
end

--- MAIN
local function TriggerInteractionThread()
    Citizen.CreateThread(function()
        Citizen.Wait(500)
        Debug('triggering interaction thread')
        -- Only needs to run once for non-target systems
        if INTERACTION_THREAD_RUNNING or Link.input.target.enabled then
            Debug('aborted', Count(PLAYER_INTERACTIONS))
            return
        end

        INTERACTION_THREAD_RUNNING = true

        while Count(PLAYER_INTERACTIONS) > 0 do
            local sleep = 1000

            -- Get all nearby interactions
            NEARBY_INTERACTIONS = GetNearbyPlayerInteractions()

            if #NEARBY_INTERACTIONS > 0 then
                sleep = 250

                -- Handle scroll input
                HandleScrollInput()

                -- Get the currently selected interaction
                local selectedInteractionData = GetCurrentSelectedInteraction()
                local interaction = selectedInteractionData and selectedInteractionData.interaction
                local distance = selectedInteractionData and selectedInteractionData.distance

                if interaction and distance < interaction.interactDist then
                    sleep = 1

                    if interaction.Handle(NEARBY_INTERACTIONS, CURRENT_INTERACTION_INDEX) and interaction.entity then
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
                end
            else
                -- Reset when no interactions nearby
                CURRENT_INTERACTION_INDEX = 1
                NEARBY_INTERACTIONS = {}

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

local function RegisterInteraction(data)
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
        icon = data.icon,

        -- Filled later
        targetEntity = nil,
        targetZone = nil,

        eventHandler = nil,
    }

    self.SafeCanInteract = function(real)
        if not real and (self.cachedCanInteractTime or 0) > GetGameTimer() - 500 then
            return self.cachedCanInteract
        end

        local success, response = pcall(self.canInteract, self.clientReturnData)
        if not success then
            Debug(
                ('^1Interactable callback (canInteract) from {resource} has failed.'):gsub('{resource}', self.invoker),
                response
            )
        end

        self.cachedCanInteract = response
        self.cachedCanInteractTime = GetGameTimer()

        return response
    end

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
            PLAYER_BUSY = true
            self.PerformSafeCallback()
            PLAYER_BUSY = false
        end)

        if self.entity then
            self.targetEntity = InputUtils.AddEntityToTargeting(self.entity, self.targetMessage, eventKey, function()
                if not self then return end
                return not PLAYER_BUSY and self.SafeCanInteract()
            end, self.meta, self.interactDist, self.icon)
        else
            self.targetZone = InputUtils.AddZoneToTargeting(self.coords, self.rotation, self.scale, self.targetMessage,
                eventKey, function()
                    if not self then return end
                    return not PLAYER_BUSY and self.SafeCanInteract()
                end, self.meta, self.interactDist, self.icon)
        end
    end

    -- Displaying and handling of the input options
    self.Handle = function(allNearbyInteractions, selectedIndex)
        if not self then
            return
        end

        if not self.SafeCanInteract() then
            return
        end

        local coords = self.GetCoords()

        local inputType = Link.input.other.inputType
        if inputType == 'top-left' then
            local message = self.message
            if allNearbyInteractions and #allNearbyInteractions > 1 then
                message = message ..
                    " (~y~" .. selectedIndex .. "/" .. #allNearbyInteractions .. "~w~ - Scroll to change)"
            end
            InputUtils.KeybindTip(message)
        elseif inputType == 'help-text' then
            local message = self.message
            if allNearbyInteractions and #allNearbyInteractions > 1 then
                message = message .. " (" .. selectedIndex .. "/" .. #allNearbyInteractions .. " - Scroll to change)"
            end
            InputUtils.DrawFloatingText(coords, message)
        elseif inputType == '3d-text' then
            if allNearbyInteractions and #allNearbyInteractions > 1 then
                Display3DTextWithOptions(coords, allNearbyInteractions, selectedIndex)
            else
                InputUtils.Draw3DText(coords, self.message, 0.042)
            end
        elseif inputType == 'kq' then
            if allNearbyInteractions and #allNearbyInteractions > 0 then
                DisplayKQInteract(allNearbyInteractions, selectedIndex, coords)
            else
                DisplayKQInteract({ { interaction = self, distance = 0 } }, 1, coords)
            end
        end

        if IsControlJustReleased(0, self.input) then
            if self.entity then
                LAST_OUTLINE_ENTITY = nil
                SetEntityDrawOutline(self.entity, false)
            end

            if self.SafeCanInteract(true) then
                self.PerformSafeCallback()
            end

            Citizen.Wait(500) -- Interaction debounce
        end

        return true
    end

    -- Perform a safe callback with error logging
    self.PerformSafeCallback = function()
        local success, err = pcall(self.callback, self.clientReturnData)
        if not success then
            Debug(
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
            InputUtils.RemoveTargetEntity(self.targetEntity)
        elseif self.targetZone then
            InputUtils.RemoveTargetZone(self.targetZone)
        end

        Debug('Delete interaction', self.key)

        PLAYER_INTERACTIONS[self.key] = nil
        self = nil
    end

    --

    self.Boot()

    -- Add the interaction to the list
    PLAYER_INTERACTIONS[self.key] = self

    Debug('Registered new interactable', json.encode(self.meta), self.GetCoords(), DoesEntityExist(self.entity))

    self.clientReturnData = {
        GetMeta = self.GetMeta,
        GetCoords = self.GetCoords,
        GetEntity = self.GetEntity,
        GetInvoker = self.GetInvoker,
        Delete = self.Delete,
    }

    return self.clientReturnData
end

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

-- CLEANUP
DeadInteractionRemovalThread()

AddEventHandler('onResourceStop', function(stoppedResource)
    for k, interaction in pairs(PLAYER_INTERACTIONS) do
        if interaction.GetInvoker() == stoppedResource then
            interaction.Delete()
        end
    end
end)
