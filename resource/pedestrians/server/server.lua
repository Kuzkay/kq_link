local PEDESTRIANS = {}

local function GetPedestrianByKey(pedKey)
    return PEDESTRIANS[pedKey] or nil
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

        state = {  
            status = 'CREATED',
        },
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
        
        self.InitBaseState()
        self.InitState()
    end
    
    --- SPAWNING
    self.Spawn = function()
        self.entity = CreatePed('CIVMALE', self.model, self.coords, self.heading, 1, 1)
    end
    
    self.InitBaseState = function()
        Entity(self.entity).state.kq_link_ped_base = {
            key = self.key,
            coords = self.coords,
            heading = self.heading,
            
            noRespawn = self.noRespawn,
            respawnTime = self.respawnTime,
            
            animation = self.animation,
            weapon = self.weapon,
            
            guard = self.guard,
        }
    end
    
    self.InitState = function()
        Entity(self.entity).state.kq_link_ped_state = self.state
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
        CombatEntity = self.CombatEntity,
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
