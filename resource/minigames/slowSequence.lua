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

local function DrawSecRect(x, y, w, h, r, g, b, a)
    DrawRect(x + w * 0.5, y + h * 0.5, w, h, r, g, b, math.floor(a))
end

local function DrawSeqText(x, y, text, scale, r, g, b, a, outline)
    SetTextFont(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, math.floor(a))
    SetTextCentre(true)
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

local function DrawMultiMinigameBoxes(multiSequences, currentStep, progress, pressedFlags, coords, label, infoText, alpha, boostPos)
    alpha = alpha or 1
    local onScreen, sx, sy = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    if not onScreen then return end

    local seqCount    = #multiSequences
    local boxW, boxH  = 0.02, 0.03
    local stepSpace   = 0.002
    local rowSpace    = 0.003

    local totalHeight = seqCount * boxH + (seqCount - 1) * rowSpace
    local startY      = sy - (totalHeight * 0.5)
    
    local labelY = startY - 0.04
    if label and label ~= "" then
        DrawSeqText(sx, labelY, label, 0.18, 255, 255, 255, 255 * alpha, true)
    end
    local infoY = startY + totalHeight
    if infoText and infoText ~= "" then
        DrawSeqText(sx, infoY, infoText, 0.15, 255, 255, 255, 255 * alpha, true)
    end

    for s = 1, seqCount do
        local sequence   = multiSequences[s]
        local seqSteps   = #sequence
        local rowY       = startY + (s - 1) * (boxH + rowSpace)
        local totalW     = seqSteps * boxW + (seqSteps - 1) * stepSpace
        local rowStartX  = sx - (totalW * 0.5)
        local cStep      = currentStep[s]
        local cProgress  = progress[s]
        local rowPressed = pressedFlags[s]

        for i = 1, seqSteps do
            local bx = rowStartX + (i - 1) * (boxW + stepSpace)
            if rowPressed[i] then
                DrawSecRect(bx, rowY - boxH * 0.5, boxW, boxH, 108, 240, 156, 180 * alpha)
            elseif i == cStep then
                DrawSecRect(bx, rowY - boxH * 0.5, boxW, boxH, 0, 0, 0, 180 * alpha)
                
                local fillW = boxW * cProgress
                if boostPos and boostPos + 0.1 > cProgress then
                    DrawSecRect(bx + boxW * boostPos, rowY - boxH * 0.5, boxW * 0.1, boxH, 108, 255, 156, 75 * alpha)
                end
                
                DrawSecRect(bx, rowY - boxH * 0.5, fillW, boxH, 108, 240, 156, 180 * alpha)
            else
                DrawSecRect(bx, rowY - boxH * 0.5, boxW, boxH, 0, 0, 0, 180 * alpha)
            end

            local stepData = sequence[i]
            local textX = bx + boxW * 0.5
            local textY = rowY - boxH * 0.5 + 0.005
            local labelText = stepData.label or "??"
            local tScale = 0.3 - (0.022 * #labelText)
            if tScale < 0.18 then tScale = 0.18 end
            DrawSeqText(textX, textY, labelText, tScale, 255, 255, 255, 255 * alpha, false)
        end
    end
end

function HoldSequenceMinigame(coords, sequenceCount, length, timePerInput, allowSkips, label, infoText)
    sequenceCount = math.max(1, sequenceCount)
    
    local seed = GetGameTimer()
    local multiSequences = {}
    for s = 1, sequenceCount do
        local seq = {}
        for i = 1, length do
            seq[i] = sequenceKeys[math.random(#sequenceKeys)]
        end
        multiSequences[s] = seq
    end

    local currentStep  = {}
    local progress     = {}
    local pressedFlags = {}
    for s = 1, sequenceCount do
        currentStep[s]  = 1
        progress[s]     = 0.0
        pressedFlags[s] = {}
        for i = 1, length do
            pressedFlags[s][i] = false
        end
    end

    local finished = false
    local prevTime = nil

    while not finished do
        Citizen.Wait(0)
        
        if IsRawKeyDown(0x1B) or IsRawKeyDown(0x08) then
            return false
        end
        
        DisablePlayerInput()
        
        local boostPos
        if sequenceCount == 1 and allowSkips then
            math.randomseed(seed .. currentStep[1])
            boostPos = math.random(5, 8) / 10
        end

        DrawMultiMinigameBoxes(multiSequences, currentStep, progress, pressedFlags, coords, label, infoText, 1, boostPos)

        local allDone = true
        for s = 1, sequenceCount do
            if currentStep[s] <= length then
                allDone = false
                break
            end
        end
        if allDone then
            finished = true
        else
            local now = GetGameTimer()
            if not prevTime then
                prevTime = now
            end
            local deltaMS = now - prevTime
            prevTime      = now

            for s = 1, sequenceCount do
                if currentStep[s] <= length then
                    local stepData   = multiSequences[s][currentStep[s]]
                    local correctKey = stepData.code
                    if IsRawKeyDown(correctKey) then
                        local fillSpeed = deltaMS / timePerInput
                        progress[s] = progress[s] + fillSpeed
                        if progress[s] >= 1.0 then
                            progress[s] = 1.0
                            pressedFlags[s][currentStep[s]] = true
                            currentStep[s] = currentStep[s] + 1
                            progress[s] = 0.0
                        end
                    else
                        if boostPos and progress[s] >= boostPos + 0.02 and progress[s] <= boostPos + 0.12 then
                            progress[s] = 1.0
                            pressedFlags[s][currentStep[s]] = true
                            currentStep[s] = currentStep[s] + 1
                            progress[s] = 0.0
                        else
                            progress[s] = 0
                        end
                    end
                end
            end
        end
    end

    local endDuration = 300
    local endTime     = GetGameTimer() + endDuration
    while GetGameTimer() < endTime do
        Citizen.Wait(0)
        DisablePlayerInput()
        local alpha = math.max(0, (endTime - GetGameTimer()) / endDuration)

        DrawMultiMinigameBoxes(multiSequences, currentStep, progress, pressedFlags, coords, label, infoText, alpha)
    end

    return true
end
