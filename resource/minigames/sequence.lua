-- https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
local sequenceKeys = {
    { code = 0x56, label = "V" },
    { code = 0x43, label = "C" },
    { code = 0x52, label = "R" },
    { code = 0x51, label = "Q" },
    { code = 0x47, label = "G" },
    { code = 0x45, label = "E" },
    { code = 0x58, label = "X" },
    { code = 0x59, label = "Y" },
    { code = 0x48, label = "H" },
    { code = 0x5A, label = "Z" },
}

local function GenerateSequence(len)
    local seq = {}
    for i = 1, len do
        seq[i] = sequenceKeys[math.random(#sequenceKeys)]
    end
    return seq
end

local function DrawSequenceRect(x, y, w, h, r, g, b, a)
    DrawRect(x + w / 2, y + h / 2, w, h, r, g, b, math.floor(a))
end

local function DrawSequenceText(x, y, text, scale, r, g, b, a, center, outline)
    SetTextFont(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, math.floor(a))
    SetTextCentre(center)
    if outline then
        SetTextDropshadow(1, 0, 0, 0, 50)
        SetTextOutline()
    end
    SetTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawText(x, y)
end

local function DrawLabelAndInfo(sx, sy, totalHeight, label, infoText, alpha)
    alpha = alpha or 1
    local labelY = sy - (totalHeight * 0.5) - 0.02
    local infoY  = sy + (totalHeight * 0.5) + 0.005
    
    if label and label ~= "" then
        DrawSequenceText(sx, labelY, label, 0.18, 255, 255, 255, 255 * alpha, true, true)
    end
    if infoText and infoText ~= "" then
        DrawSequenceText(sx, infoY, infoText, 0.15, 255, 255, 255, 255 * alpha, true, true)
    end
end

local function DrawMinigameBoxes(sequence, pressedFlags, coords, currentIndex, hiddenMode, label, infoText)
    local onScreen, sx, sy = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    if not onScreen then return end

    local boxW, boxH = 0.02, 0.03
    local spacing    = 0.002
    local count      = #sequence
    local totalW     = (count * boxW) + ((count - 1) * spacing)
    local startX     = sx - (totalW * 0.5)
    
    for i, keyData in ipairs(sequence) do
        local bx = startX + (i - 1) * (boxW + spacing)

        local r, g, b = 0, 0, 0
        if pressedFlags[i] then
            r, g, b = 108, 240, 156
        end
        DrawSequenceRect(bx, sy - boxH / 2, boxW, boxH, r, g, b, 180)

        local label = keyData.label
        if hiddenMode and currentIndex > 1 and (not pressedFlags[i]) then
            local scrambled = {'#', '?', '$', '%'}
            label = scrambled[((math.floor(GetGameTimer() / 50) + i) % #scrambled) + 1]
        end

        local textX = bx + (boxW / 2)
        local textY = sy - (boxH / 2) + 0.004
        local textScale = 0.3 - (0.022 * #label)
        if textScale < 0.18 then textScale = 0.18 end
        DrawSequenceText(textX, textY, label, textScale, 255, 255, 255, 255, true)
    end
    
    DrawLabelAndInfo(sx, sy, boxH, label, infoText)
end

local function DrawFinalSequence(sequence, coords, colorMode, label, infoText, alpha)
    local onScreen, sx, sy = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    if not onScreen then return end

    local boxW, boxH = 0.02, 0.03
    local spacing    = 0.002
    local count      = #sequence
    local totalW     = (count * boxW) + ((count - 1) * spacing)
    local startX     = sx - (totalW * 0.5)

    local r, g, b    = 108, 240, 156
    if colorMode == 'red' then
        r, g, b = 200, 50, 50
    end
    
    for i, keyData in ipairs(sequence) do
        local bx = startX + (i - 1) * (boxW + spacing)

        DrawSequenceRect(bx, sy - boxH / 2, boxW, boxH, r, g, b, 180 * alpha)

        local label = keyData.label
        local textX = bx + (boxW / 2)
        local textY = sy - (boxH / 2) + 0.004
        local textScale = 0.3 - (0.022 * #label)
        if textScale < 0.18 then textScale = 0.18 end

        DrawSequenceText(textX, textY, label, textScale, 255, 255, 255, 255 * alpha, true)
    end
    
    DrawLabelAndInfo(sx, sy, boxH, label, infoText, alpha)
end

local function DisablePlayerInput()
    for group = 0, 2 do
        DisableAllControlActions(group)
    end
    -- Re-enable camera look + zoom
    EnableControlAction(0, 1, true)   -- LookLeftRight
    EnableControlAction(0, 2, true)   -- LookUpDown
    EnableControlAction(0, 241, true) -- MouseWheelUp  (zoom)
    EnableControlAction(0, 242, true) -- MouseWheelDown (zoom)
end

function SequenceMinigame(coords, length, hiddenMode, label, infoText)
    local sequence = GenerateSequence(length)
    local pressedFlags = {}
    for i = 1, length do
        pressedFlags[i] = false
    end

    local currentIndex = 1
    local gameActive   = true
    local wasSuccess   = false

    while gameActive do
        Citizen.Wait(0)
        
        if IsRawKeyDown(0x1B) or IsRawKeyDown(0x08) then
            return false
        end

        DisablePlayerInput()

        DrawMinigameBoxes(sequence, pressedFlags, coords, currentIndex, hiddenMode, label, infoText)

        local correctCode = sequence[currentIndex].code

        if IsRawKeyReleased(correctCode) then
            pressedFlags[currentIndex] = true
            currentIndex = currentIndex + 1
            if currentIndex > #sequence then
                wasSuccess = true
                gameActive = false
            end
        else
            for _, keyData in ipairs(sequenceKeys) do
                if IsRawKeyReleased(keyData.code) then
                    if keyData.code ~= correctCode then
                        wasSuccess = false
                        gameActive = false
                    end
                    break
                end
            end
        end
    end

    local endDuration, colorMode
    if wasSuccess then
        colorMode = 'green'
        endDuration = 500
    else
        colorMode = 'red'
        endDuration = 1000
    end
    
    local endTime = GetGameTimer() + endDuration
    while GetGameTimer() < endTime do
        Citizen.Wait(0)
        DisablePlayerInput()

        local alpha = math.max(0, (endTime - GetGameTimer()) / endDuration)
        
        DrawFinalSequence(sequence, coords, colorMode, label, infoText, alpha)
    end

    return wasSuccess
end
