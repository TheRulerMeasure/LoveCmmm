-- bathbomb --

local math2 = require "src.math2"

local BathBomb = {}
local mtBathBomb = { __index=BathBomb }

function BathBomb.new(x, y, config)
    
    local conf = config or {}
    
    local self = setmetatable({}, mtBathBomb)
    
    self.color = conf.color or { 1, 1, 1, 1 }
    self.bombType = conf.bombType or "star"
    
    local amount = conf.amount or 5
    
    local x = x or 0
    local y = y or x or 0
    
    local minSpeed = conf.minSpeed or 120
    local maxSpeed = conf.maxSpeed or 180
    
    local minLifeTime = conf.minLifeTime or 0.75
    local maxLifeTime = conf.maxLifeTime or 1.3
    
    local minRotateSpeed = conf.minRotateSpeed or -20
    local maxRotateSpeed = conf.maxRotateSpeed or 20
    
    self.bombs = {}
    
    for i = 1, amount do
        
        local r = love.math.random() * (math.pi + math.pi)
        local speed = math2.randRange(minSpeed, maxSpeed)
        
        self.bombs[i] = {
            
            x = x,
            y = y,
            
            r = math2.randRange(-math.pi, math.pi),
            
            velX = math.cos(r) * speed,
            velY = math.sin(r) * speed,
            
            rotateSpeed = math2.randRange(minRotateSpeed, maxRotateSpeed),
            
            lifeTime = math2.randRange(minLifeTime, maxLifeTime),
            
        }
    end
    
    return self
    
end

function BathBomb:update(dt)
    
    local hasBomb = false
    
    for i = #self.bombs, 1, -1 do
        hasBomb = true
        
        local b = self.bombs[i]
        
        b.x = b.x + b.velX * dt
        b.y = b.y + b.velY * dt
        
        b.r = b.r + b.rotateSpeed * dt
        
        b.lifeTime = b.lifeTime - dt
        if b.lifeTime <= 0 then
            table.remove(self.bombs, i)
        end
        
    end
    
    if not hasBomb then
        self._dead = true
    end
end

function BathBomb:draw()
    
    local spr
    
    if self.bombType == "star" then
        spr = g_SprStar
    elseif self.bombType == "cloud" then
        spr = g_SprCloud
    end
    
    love.graphics.setColor(self.color)
    
    for i, b in ipairs(self.bombs) do
        
        spr:drawCenter(1, b.x, b.y, b.r)
        
    end
    
end

function BathBomb:destroy()
    
end

return BathBomb
