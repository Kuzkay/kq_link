
local function DrawProgressRect(x, y, w, h, r, g, b, a)
    DrawRect(x + w * 0.5, y + h * 0.5, w, h, r, g, b, a)
end

local function DrawProgressBar(coords, fraction, alpha, scale)
    local onScreen, sx, sy = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    if not onScreen then return end
    
    local boxW, boxH = 0.1 * scale, 0.018 * scale
    
    fraction = math.max(0.0, math.min(fraction, 1.0))
    alpha = math.max(0, math.min(alpha, 255))
    
    DrawProgressRect(sx - 0.001 - (boxW / 2), sy - 0.0015 - (boxH * 0.5), boxW + 0.002, boxH + 0.003, 0, 0, 0, math.floor(alpha * 0.7))
    
    local fillW = boxW * fraction
    DrawProgressRect(sx - (boxW / 2), sy - (boxH * 0.5), fillW, boxH, 108, 240, 156, math.floor(alpha * 0.9))
end

function ProgressBar(coords, duration, baseScale)
    baseScale = baseScale or 1
    
    local maxDist = 30.0
    local fillTime    = duration
    local holdTime    = 250
    
    local fadeInTime  = 250
    local fadeOutTime = 250
    
    local startTime   = GetGameTimer()
    local fadeInEnd   = startTime + fadeInTime
    local fillStart   = fadeInEnd
    local fillEnd     = fillStart + fillTime
    local holdEnd     = fillEnd + holdTime
    local fadeOutEnd  = holdEnd + fadeOutTime
    
    while true do
        Citizen.Wait(0)
        
        local camCoords = GetFinalRenderedCamCoord()
        local dist = #(camCoords - coords)
        local scale = baseScale
        
        if dist > 4.0 then
            scale = (baseScale * ((maxDist - dist) / maxDist))
        end
        
        local now = GetGameTimer()
        
        if scale > 0.1 then
            local alpha
            if now < fadeInEnd then
                local pct = (now - startTime) / fadeInTime
                alpha = math.floor(255 * pct)
            elseif now < holdEnd then
                alpha = 255
            else
                local pct = (now - holdEnd) / fadeOutTime
                alpha = math.floor(255 * (1.0 - pct))
            end
            
            local fraction
            if now < fillStart then
                fraction = 0.0
            elseif now < fillEnd then
                local pct = (now - fillStart) / fillTime
                fraction = pct
            else
                fraction = 1.0
            end
            
            DrawProgressBar(coords + vec3(0, 0, 0.1), fraction, alpha, scale)
        end
        
        if now >= fadeOutEnd then
            break
        end
    end
    
    return true
end
