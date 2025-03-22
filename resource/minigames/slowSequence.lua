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
    DrawRect(x + w * 0.5, y + h * 0.5, w, h, r, g, b, math.floor(a))
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

local function DisablePlayerInput()
    for group = 0, 2 do
        DisableAllControlActions(group)
    end
    EnableControlAction(0, 1, true)
    EnableControlAction(0, 2, true)
    EnableControlAction(0, 241, true)
    EnableControlAction(0, 242, true)
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

local function DrawMinigameBoxes(sequence, pressedFlags, holdProgress, coords, currentIndex, label, infoText)
    local onScreen, sx, sy = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    if not onScreen then return end

    local boxW, boxH  = 0.02, 0.03
    local spacing     = 0.002

    local count       = #sequence
    local totalW      = (count * boxW) + ((count - 1) * spacing)
    local startX      = sx - (totalW * 0.5)
    
    for i, keyData in ipairs(sequence) do
        local bx = startX + (i - 1) * (boxW + spacing)

        local r, g, b = 0, 0, 0
        if pressedFlags[i] then
            r, g, b = 108, 240, 156
        end

        DrawSequenceRect(bx, sy - boxH * 0.5, boxW, boxH, r, g, b, 180)

        if not pressedFlags[i] and i == currentIndex then
            local fraction = holdProgress[i]
            if fraction > 1.0 then fraction = 1.0 end
            local fillW = boxW * fraction
            DrawSequenceRect(bx, sy - boxH * 0.5, fillW, boxH, 108, 240, 156, 180)
        end

        local labelText = keyData.label
        local textX = bx + (boxW * 0.5)
        local textY = sy - (boxH * 0.5) + 0.005
        local textScale = 0.3 - (0.022 * #labelText)
        if textScale < 0.18 then textScale = 0.18 end
        DrawSequenceText(textX, textY, labelText, textScale, 255, 255, 255, 255, true)
    end

    DrawLabelAndInfo(sx, sy, boxH, label, infoText)
end

local function DrawFinalSequence(sequence, coords, label, infoText, alpha)
    local onScreen, sx, sy = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    if not onScreen then return end

    local boxW, boxH  = 0.02, 0.03
    local spacing     = 0.002
    local count       = #sequence
    local totalW      = (count * boxW) + ((count - 1) * spacing)
    local startX      = sx - (totalW * 0.5)

    for i, keyData in ipairs(sequence) do
        local bx = startX + (i - 1) * (boxW + spacing)

        DrawSequenceRect(bx, sy - boxH * 0.5, boxW, boxH, 108, 240, 156, 180 * alpha)

        local labelText = keyData.label
        local textX = bx + (boxW * 0.5)
        local textY = sy - (boxH * 0.5) + 0.005
        local textScale = 0.3 - (0.022 * #labelText)
        if textScale < 0.18 then textScale = 0.18 end
        DrawSequenceText(textX, textY, labelText, textScale, 255, 255, 255, 255 * alpha, true)
    end

    DrawLabelAndInfo(sx, sy, boxH, label, infoText, alpha)
end

function HoldSequenceMinigame(coords, length, timePerInput, label, infoText)
    local sequence = GenerateSequence(length)

    local pressedFlags = {}
    local holdProgress = {}
    for i = 1, length do
        pressedFlags[i] = false
        holdProgress[i] = 0.0
    end

    local currentIndex = 1
    local finished     = false

    local decRate      = 2

    while not finished do
        Citizen.Wait(0)
        DisablePlayerInput()

        -- Draw UI
        DrawMinigameBoxes(
            sequence, pressedFlags, holdProgress,
            coords,
            currentIndex,
            label,
            infoText
        )

        if currentIndex > #sequence then
            finished = true
        else
            local now = GetGameTimer()
            if not holdProgress._prevTime then
                holdProgress._prevTime = now
            end
            local deltaMS          = now - holdProgress._prevTime
            holdProgress._prevTime = now

            local correctCode      = sequence[currentIndex].code

            if IsRawKeyDown(correctCode) then
                holdProgress[currentIndex] = holdProgress[currentIndex] + (deltaMS / timePerInput)
                if holdProgress[currentIndex] >= 1.0 then
                    pressedFlags[currentIndex] = true
                    holdProgress[currentIndex] = 1.0
                    currentIndex = currentIndex + 1
                    holdProgress._prevTime = nil
                end
            else
                local decAmount = (deltaMS / timePerInput) * decRate
                holdProgress[currentIndex] = holdProgress[currentIndex] - decAmount
                if holdProgress[currentIndex] < 0.0 then
                    holdProgress[currentIndex] = 0.0
                end
            end
        end
    end

    local endDuration = 300
    local endTime = GetGameTimer() + endDuration
    while GetGameTimer() < endTime do
        Citizen.Wait(0)
        DisablePlayerInput()
        DrawFinalSequence(sequence, coords, label, infoText, math.max(0, (endTime - GetGameTimer()) / endDuration))
    end

    return true
end

--------------------------------------------------------------------------------
-- Example usage:
--Citizen.CreateThread(function()
--    local coords = GetEntityCoords(PlayerPedId())
--    local success = HoldSequenceMinigame(
--        coords,
--        8,                           -- length
--        1.0,                         -- timePerInput
--        "Searching through the bag...", -- label
--        "Hold each key to progress"  -- infoText
--    )
--    print("Hold minigame ended; success =", success)
--end)
