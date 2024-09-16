local PEDESTRIANS = {}

local STATUSES = {
    combat = 'COMBAT',
    returning = 'RETURNING',
    idle = 'IDLE',
    respawning = 'RESPAWNING',
}

local CLIENT_TASKS = {
    TaskFollowNavMeshToCoord = 'TaskFollowNavMeshToCoord',
    TaskPlayAnim = 'TaskPlayAnim',
}

local function GetPedestrianByKey(pedKey)
    return PEDESTRIANS[pedKey] or nil
end

local function TaskPedestrianCombatSelf(player, pedKey)
    local pedestrian = GetPedestrianByKey(pedKey)
    
    if pedestrian == nil or not DoesEntityExist(pedestrian.entity) then
        return
    end
    
    pedestrian.CombatEntity(GetPlayerPed(player))
end

RegisterServerEvent('kq_link:server:pedestrians:markConfigured')
AddEventHandler('kq_link:server:pedestrians:markConfigured', function(pedKey)
    local pedestrian = GetPedestrianByKey(pedKey)
    
    if not pedestrian then
        return
    end
    
    pedestrian.SetConfigured()
end)

RegisterServerEvent('kq_link:server:pedestrians:combatPlayer')
AddEventHandler('kq_link:server:pedestrians:combatPlayer', function(pedKey)
    TaskPedestrianCombatSelf(source, pedKey)
end)

local function RegisterPedestrian(data)
    local self = {
        invoker = GetInvokingResource(),
        
        key = GetGameTimer() .. '-' .. math.random(0, 9999999),
        
        configured = false,
        
        coords = data.coords,
        heading = data.heading,
        
        model = data.model,
        
        noRespawn = data.noRespawn or false,
        respawnTime = data.respawnTime or 30000,
        
        status = nil,
        
        clientTask = nil,
    }
    
    self.Boot = function()
        if data.animation then
            self.animation = data.animation
        end
        
        if data.guard then
            self.guard = {
                coords = data.guard.coords or data.coords,
                radius = data.guard.radius or 1.0,
            }
        end
        
        if data.weapon then
            self.weapon = {
                hash = data.weapon.hash or 'WEAPON_PISTOL',
                hidden = data.weapon.hidden or false,
            }
        end
        
        self.Spawn()
        
        Citizen.Wait(1000)
        self.RunMainThread()
    end
    
    --- SPAWNING
    self.Spawn = function()
        if self.entity and DoesEntityExist(self.entity) then
            DeleteEntity(self.entity)
        end
        
        self.entity = CreatePed('CIVFEMALE', self.model, self.coords, self.heading, 1, 1)
        
        if self.animation then
            self.SetClientTask(CLIENT_TASKS.TaskPlayAnim, {self.animation.dict, self.animation.name, 2.0, 2.0, -1, 1, 1.0, 0, 0, 0}, STATUSES.IDLE)
        end
        
        if self.weapon then
            GiveWeaponToPed(self.entity, self.weapon.hash, 999, self.weapon.hidden, not self.weapon.hidden)
        end
        
        self.SetStatus(STATUSES.idle)
    end
    
    self.SetStatus = function(newStatus)
        self.status = newStatus
        self.UpdateState()
    end
    
    self.SetClientTask = function(task, meta, status)
        self.clientTask = {
            task = task,
            meta = meta,
            status = status,
        }
        self.UpdateState()
    end
    
    self.ResetClientTask = function()
        self.clientTask = nil
        self.UpdateState()
    end
    
    self.UpdateState = function()
        Entity(self.entity).state.kq_link_ped = {
            key = self.key,
            configured = self.configured,
            
            status = self.status,
            
            guard = self.guard,
            
            clientTask = self.clientTask,
            
            lastUpdate = GetGameTimer(),
        }
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
        self.SetStatus(STATUSES.respawning)
        
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
                
                self.RespawnIfNeeded()
                
                self.HandleReturning()
                
                self.UpdateState()
                
                Citizen.Wait(3000)
            end
        end)
    end
    
    --- BASE TASKS
    self.ReturnToStart = function()
        self.SetClientTask(CLIENT_TASKS.TaskFollowNavMeshToCoord, {self.coords, 2.0, 30 * 1000, 0.1, 0, self.heading})
        self.SetStatus(STATUSES.returning)
    end
    
    self.HandleReturning = function()
        local distance = #(GetEntityCoords(self.entity) - self.coords)
        if self.status == STATUSES.idle and distance > 0.2 then
            self.ReturnToStart()
        end
        
        if self.status == STATUSES.returning and distance < 0.5 then
            ClearPedTasks(self.entity)
            
            SetEntityCoords(self.entity, self.coords + vector3(0, 0, -1))
            SetEntityHeading(self.entity, self.heading)
            
            self.ResetClientTask()
            self.SetStatus(STATUSES.idle)
            
            if self.animation then
                self.SetClientTask(CLIENT_TASKS.TaskPlayAnim, {self.animation.dict, self.animation.name, 2.0, 2.0, -1, 1, 1.0, 0, 0, 0}, STATUSES.idle)
            end
        end
        
        if self.status == STATUSES.returning or distance > 30.0 then
            self.ReturnToStart()
        end
    end
    
    --- ADVANCED TASKS
    self.CombatEntity = function(entity)
        if self.status ~= STATUSES.combat then
            ClearPedTasks(self.entity)
            TaskCombatPed(self.entity, entity, 0, 16)
            self.ResetClientTask()
            self.SetStatus(STATUSES.combat)
            
            Citizen.SetTimeout(60000, function()
                if self.status == STATUSES.combat then
                    self.ReturnToStart()
                end
            end)
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
    
    self.SetConfigured = function()
        self.configured = true
        self.UpdateState()
    end
    
    
    ---
    self.Boot()
    
    PEDESTRIANS[self.key] = self
    
    return {
        Delete = self.Delete,
        CombatEntity = self.CombatEntity,
        GetEntity = self.GetEntity,
        GetInvoker = self.GetInvoker,
        SetConfigured = self.SetConfigured,
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
        
        guard = {
            coords = data.guard.coords or data.coords,
            radius = data.guard.radius or 1.0,
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
