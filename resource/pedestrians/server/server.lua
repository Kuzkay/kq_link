local PEDESTRIANS = {}

local STATES = {
    combat = 'COMBAT',
    returning = 'RETURNING',
    idle = 'IDLE',
}

local function GetCachedPlayersInformation()
    return UseCache('GetPlayersInformation', function()
        local players = {}
        for _, playerId in ipairs(GetPlayers()) do
            local playerPed = GetPlayerPed(playerId)
            local playerCoords = GetEntityCoords(playerPed)

            table.insert(players, {
                player = playerId,
                ped = playerPed,
                coords = playerCoords,
            })
        end

        for _, playerId in ipairs(GetAllPeds()) do
            local playerPed = playerId
            local playerCoords = GetEntityCoords(playerPed)

            table.insert(players, {
                player = playerId,
                ped = playerPed,
                coords = playerCoords,
            })
        end
        
        return players
    end, 10000)
end

local function GetPlayersInDistance(coords, maxDistance)
    local players = {}
    for _, playerCache in ipairs(GetCachedPlayersInformation()) do
        local cachedDistance = #(coords - playerCache.coords)
        
        if maxDistance > cachedDistance then
            local realCoords = GetEntityCoords(playerCache.ped)
            local distance = #(coords - realCoords)
            
            table.insert(players, {
                player = playerCache.player,
                ped = playerCache.ped,
                distance = distance,
                coords = realCoords,
            })
        end
    end
    
    return players
end

local function RegisterPedestrian(data)
    local self = {
        invoker = GetInvokingResource(),
        
        key = GetGameTimer() .. '-' .. math.random(0, 9999999),
        
        coords = data.coords,
        heading = data.heading,
        
        model = data.model,
        
        noRespawn = data.noRespawn or false,
        respawnTime = data.respawnTime or 30000,
        
        state = nil,
        
        combat = {
            entity = nil,
            startTime = 0,
        }
    }
    
    self.Boot = function()
        if data.animation then
            self.animation = data.animation
        end
        if data.guardZone then
            self.guardZone = {
                coords = data.guardZone.coords or data.coords,
                radius = data.guardZone.radius or 1.0,
            }
        end
        if data.weapon then
            self.weapon = {
                hash = data.weapon.hash or 'WEAPON_PISTOL',
                hidden = data.weapon.hidden or false,
            }
        end
        
        self.Spawn()
        
        Citizen.Wait(1000
        )
        self.RunMainThread()
    end
    
    --- SPAWNING
    self.Spawn = function()
        if self.entity and DoesEntityExist(self.entity) then
            DeleteEntity(self.entity)
        end
        
        self.entity = CreatePed('CIVFEMALE', self.model, self.coords, self.heading, 1, 1)
        
        if self.animation then
            TaskPlayAnim(self.entity, self.animation.dict, self.animation.name, 1.5, 1.5, -1, 1, 1.0, 0, 0, 0)
        end
        
        if self.weapon then
            GiveWeaponToPed(self.entity, self.weapon.hash, 999, self.weapon.hidden, not self.weapon.hidden)
        end
        
        self.state = STATES.idle
    end
    
    self.RespawnIfNeeded = function()
        if not DoesEntityExist(self.entity) then
            self.Respawn()
            return
        end
        if GetEntityHealth(self.entity) <= 0.0 then
            self.Respawn()
            return
        end
    end
    
    self.Respawn = function()
        local respawnTime = GetGameTimer() + self.respawnTime
        
        while respawnTime > GetGameTimer() do
            Citizen.Wait(1000)
        end
        
        if not self then
            return
        end
        
        if self.noRespawn then
            self.Delete()
            return
        end
        
        self.Spawn()
    end
    
    --- THREADS
    self.RunMainThread = function()
        Citizen.CreateThread(function()
            while self ~= nil do
                
                if self.guardZone then
                    self.HandleGuarding()
                end
                
                self.RespawnIfNeeded()
                
                self.HandleReturning()
                
                
                Debug(self.state)
                
                Citizen.Wait(2000)
            end
        end)
    end
    
    --- TASKS
    self.ReturnToStart = function()
        TaskGoStraightToCoord(self.entity, self.coords, 1.0, 20 * 1000, self.heading, 1.0)
        self.state = STATES.returning
    end
    
    self.HandleGuarding = function()
        if self.state == STATES.combat then
            
            if #(GetEntityCoords(self.combat.entity) - GetEntityCoords(self.entity)) > 15.0 then
                self.ReturnToStart()
            else
                TaskCombatPed(self.entity, self.combat.entity, 0, 16)
            end
            
            return true
        end
        
        local players = GetPlayersInDistance(self.guardZone.coords, self.guardZone.radius + 75)
        
        Debug('Players in radius', #players)
        for k, playerData in pairs(players) do
            if self.guardZone.radius >= playerData.distance then
                self.combat.entity = playerData.ped
                self.combat.startTime = GetGameTimer()
                self.state = STATES.combat
                
                TaskCombatPed(self.entity, playerData.ped, 0, 16)
                
                return true
            end
        end
        
        return false
    end
    
    self.HandleReturning = function()
        if #(GetEntityCoords(self.entity) - self.coords) > 25.0 then
            self.ReturnToStart()
        elseif self.state == STATES.returning and #(GetEntityCoords(self.entity) - self.coords) < 1.5 then
            ClearPedTasksImmediately(self.entity)
            
            SetEntityCoords(self.entity, self.coords + vector3(0, 0, -1))
            SetEntityHeading(self.entity, self.heading)
            
            if self.animation then
                TaskPlayAnim(self.entity, self.animation.dict, self.animation.name, 1.5, 1.5, -1, 1, 1.0, 0, 0, 0)
            end
            
            self.state = STATES.idle
        end
    end
    
    --- FUNCTIONS
    self.Delete = function()
        DeleteEntity(self.entity)
        PEDESTRIANS[self.key] = nil
        self = nil
        return true
    end
    
    --- GETTERS
    self.GetEntity = function()
        return self.entity
    end
    
    self.GetInvoker = function()
        return self.invoker
    end
    
    
    ---
    self.Boot()
    
    PEDESTRIANS[self.key] = self
    
    return {
        Delete = self.Delete,
        GetEntity = self.GetEntity,
        GetInvoker = self.GetInvoker,
    }
end

function AddGuardPedestrian(data)
    return RegisterPedestrian({
        coords = data.coords,
        heading = data.heading,
        
        model = data.model,
        
        noRespawn = data.noRespawn or false,
        respawnTime = data.respawnTime or 30000,
        
        animation = {
            dict = data.animation.dict or 'switch@michael@talks_to_guard',
            name = data.animation.name or '001393_02_mics3_3_talks_to_guard_idle_guard',
        },
        
        guardZone = {
            coords = data.guardZone.coords or data.coords,
            radius = data.guardZone.radius or 1.0,
        },
        
        weapon = {
            hash = data.weapon.hash or 'WEAPON_FLASHLIGHT',
            hidden = data.weapon.hidden or false,
        }
    })
end

-- CLEANUP
AddEventHandler('onResourceStop', function(stoppedResource)
    for k, pedestrian in pairs(PEDESTRIANS) do
        if pedestrian.GetInvoker() == stoppedResource then
            pedestrian.Delete()
        end
    end
end)
