local STATUSES = {
    combat = 'COMBAT',
    returning = 'RETURNING',
    idle = 'IDLE',
}

local CLIENT_TASKS = {
    TaskFollowNavMeshToCoord = 'TaskFollowNavMeshToCoord',
}

local function GetPedLinkData(ped)
    return UseCache('GetPedLinkData' .. ped, function()
        return Entity(ped).state.kq_link_ped
    end, 1000)
end

local function IsLinkPed(ped)
    return UseCache('isLinkPed' .. ped, function()
        return GetPedLinkData(ped) ~= nil
    end, 15000)
end

local function GetLinkPeds()
    return UseCache('GetLinkPeds', function()
        local linkPeds = {}
        for k, ped in pairs(GetGamePool('CPed')) do
            if IsLinkPed(ped) and DoesEntityExist(ped) then
                table.insert(linkPeds, ped)
            end
        end
        return linkPeds
    end, 5000)
end

local function GetPlayerCoords()
    return UseCache('GetPlayerCoords', function()
        return GetEntityCoords(PlayerPedId())
    end, 1000)
end

---
local function DoGuardChecks(ped)
    local linkData = GetPedLinkData(ped)
    
    if linkData.guard then
        local playerCoords = GetPlayerCoords()
        local distanceToZone = #(playerCoords - linkData.guard.coords)
        if distanceToZone <= linkData.guard.radius then
            TriggerServerEvent('kq_link:server:pedestrians:combatPlayer', linkData.key)
        end
    end
end

---
local function PerformClientTasks(ped)
    local linkData = GetPedLinkData(ped)
    
    local clientTask = linkData.clientTask
    if clientTask == nil then
        return
    end
    
    if clientTask.task == CLIENT_TASKS.TaskFollowNavMeshToCoord then
        TaskFollowNavMeshToCoord(ped, table.unpack(clientTask.meta))
        return
    end
end

Citizen.CreateThread(function()
    while true do
        local sleep = 5000
        
        for k, ped in pairs(GetLinkPeds()) do
            sleep = 1000
            local linkData = GetPedLinkData(ped)
            
            if linkData then
                if linkData.status == STATUSES.idle or linkData.status == STATUSES.returning then
                    DoGuardChecks(ped)
                end
                
                if NetworkHasControlOfEntity(ped) then
                    PerformClientTasks(ped)
                end
            end
        end
        
        Citizen.Wait(sleep)
    end
end)


--- DEBUG
if Link.debugMode then
    local function DrawLinkPedData(ped)
        local coords = GetEntityCoords(ped)
        local dataString = json.encode(GetPedLinkData(ped), {indent=true})
        
        SetTextScale(0.25, 0.25)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextDropshadow(1, 1, 1, 1, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextCentre(0)
        
        AddTextEntry("link_ped_info", dataString)
        SetTextEntry("link_ped_info")
        
        SetDrawOrigin(coords, 0)
        DrawText(0.0, 0.0)
        
        ClearDrawOrigin()
    end
    
    Citizen.CreateThread(function()
        while true do
            local sleep = 5000
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            
            for k, ped in pairs(GetLinkPeds()) do
                if #(playerCoords - GetEntityCoords(ped)) <= 50.0 then
                    sleep = 1
                    DrawLinkPedData(ped)
                end
            end
            
            Citizen.Wait(sleep)
        end
    end)
end
