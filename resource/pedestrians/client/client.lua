local PEDESTRIANS = {}

local STATUSES = {
    combat = 'COMBAT',
    returning = 'RETURNING',
    idle = 'IDLE',
    dead = 'DEAD',
    respawning = 'RESPAWNING',
}

local function GetPlayerPedsCached()
    return UseCache('GetPlayerPedsCached', function() 
        local playerPeds = {}
    
        for _, playerId in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(playerId) -- Get each player's ped
            table.insert(playerPeds, ped)
        end
        return playerPeds
    end, 3000)
end


local function InitalizePedestrian(entity)
    local self = {
        entity = entity,
    }

    self.Boot() = function()
        self.FetchBaseState()
        self.FetchState()
        
        self.SetPedAttributes()

        Citizen.Wait(20) -- yield
        self.MainThread()
    end

    self.SetPedAttributes = function()
        SetBlockingOfNonTemporaryEvents(self.entity, true)
        SetPedDropsWeaponsWhenDead(self.entity, false)
    end

    self.FetchBaseState = function()
        local baseState = Entity(self.entity).state.kq_link_ped_base

        -- Mapping of the state
        for k, state in pairs(baseState) do
            self[k] = state
        end
    end

    self.FetchState = function()
        self.state = Entity(self.entity).state.kq_link_ped_state
    end

    self.PushState = function()
        Entity(self.entity).state.kq_link_ped_state = self.state
    end
    
    self.MainThread = function()
        Citizen.CreateThread(function()
                while self ~= nil do
                    local sleep = 5000
                    
                    if NetworkHasControlOfEntity(self.entity) then
                        sleep = 2000
                        self.PerformActions()
                    end
                            
                    Citizen.Wait(sleep)
                end
        end)
    end

    self.SetStatus = function(status)
        -- Already has this status
        if self.state.status == status then
            return
        end
        
        self.state.status = status
        
        self.PushState()
    end

    --- Actions
    self.PerformActions = function()
        local target = self.GetNearestTarget()
        if target then
            self.CombatTarget(target)
        else
            local distanceToSpawn = #(self.coords - GetEntityCoords(self.entity))
            if distanceToSpawn > 0.5 then
                self.ReturnToSpawn()
            else
                self.PlayBaseAnim()
            end
        end
    end

    --- Animations
    self.PlayBaseAnim = function()
        self.PlayAnim(self.animation.dict, self.animation.name)
    end
    
    self.PlayAnim = function(dict, name, flag)
        if IsEntityPlayingAnim(self.entity, dict, name, flag) then
            return
        end
        Citizen.CreateThread(function()
                while not HasAnimDictLoaded(self.animation.dict) do
                    RequestAnimDict(self.animation.dict)
                    Citizen.Wait(20)
                end
                
                TaskPlayAnim(self.entity, dict, name, 2.0, 2.0, -1, flag or 1, 1.0, 0, 0, 0)
            end)
    end
    
    --- Return
    self.ReturnToSpawn = function()
        TaskFollowNavMeshToCoord(ped.entity, ped.coords, 2.0, -1, 0.1, 0, ped.heading)
        
        self.SetStatus(STATUSSES.returning)
    end

    --- Combat
    self.CombatTarget = function(target)
        local targetEntity = NetworkGetEntityFromNetworkId(netId)
        TaskCombatPed(self.entity, targetEntity, 0, 16)
        
        self.SetStatus(STATUSSES.combat)
    end
    
    self.GetNearestTarget = function()
        local nearestTarget = nil
        local nearestDist = 50

        local selfCoords = GetEntityCoords(self.entity)
        
        for netId, target in pairs(self.state.targets or {}) do
            if NetworkDoesNetworkIdExist(netId) then
                local entity = NetworkGetEntityFromNetworkId(netId)
                if target.timeout <= GetNetworkTime() then
                    local distance = #(GetEntityCoords(entity) - selfCoords)
                    if nearestDist > distance then
                        nearestTarget = target
                        nearestDistance = distance
                    end
                else
                    self.RemoveCombatTarget(entity)
                end
            end
        end

        return nearestTarget, nearestDist
    end
    
    self.FindTargets = function()
        if not ped.guard then
            return
        end
        
        local playerPeds = GetPlayerPedsCached()
    
        for k, playerPed in pairs(playerPeds) do
            local distance = #(GetEntityCoords(playerPed) - GetEntityCoords(ped.guard.coords))
            if distance <= ped.guard.radius then        
                ped.AddCombatTarget(TASKS.TaskCombatPed, {NetworkGetNetworkIdFromEntity(playerPed), 0, 16})
            end
        end
    end
    
    self.AddCombatTarget = function(entity)    
        if not self.state.targets then
            self.state.targets = {}
        end
        
        if not NetworkGetEntityIsNetworked(entity) then
            return
        end
        
        local netId = NetworkGetNetworkIdFromEntity(entity)

        self.state.targets[netId] = {
            netId = NetworkGetNetworkIdFromEntity(entity),
            timeout = GetNetworkTime() + (60 * 1000)
        }
        
        self.UpdateState()
    end
    
    self.RemoveCombatTarget = function(entity)
        if not self.state.targets then
            self.state.targets = {}
            return
        end

        local netId = NetworkGetNetworkIdFromEntity(entity)
        
        self.state.targets[netId] = nil
        
        self.UpdateState()
    end
    
    self.ResetCombatTarget = function()
        self.state.targets = {}
        
        self.PushState()
    end
    ---

    --- End
    self.Delete = function()
        SetPedAsNoLongerNeeded(self.entity)
        PEDESTRIANS[self.entity] = nil
        self = nil
    end
    ---

    PEDESTRIANS[entity] = self
    
    return self
end






---
---






local function IsLinkPed(ped)
    return UseCache('isLinkPed' .. ped, function()
        return PEDESTRIANS[ped] or (Entity(self.entity).state.kq_link_ped_base ~= nil)
    end, 5000)
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

-- Init/Kill thread
Citizen.CreateThread(function()
        while true do
            local sleep = 1000
            
            for k, ped in pairs(GetLinkPeds()) do                
                if not PEDESTRIANS[ped] then
                    InitalizePedestrian(ped)
                end
            end

            for entity, pedObject in pairs(PEDESTRIANS) do
                if not DoesEntityExist(entity) then
                    pedObject.Delete()
                end
            end
            
            Citizen.Wait(sleep)
        end
end)


--- DEBUG
if Link.debugMode then
    local function DrawLinkPedData(ped)
        local coords = GetEntityCoords(ped.entity)
        local dataString = json.encode(ped.state, {indent=true})
        
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
            
            for k, ped in pairs(PEDESTRIANS) do
                if #(playerCoords - GetEntityCoords(ped.entity)) <= 20.0 then
                    sleep = 1
                    DrawLinkPedData(ped)
                end
            end
            
            Citizen.Wait(sleep)
        end
    end)
end
