-- ball --

local vector = require "lib.vector-light"


local function dirTo(x1, y1, x2, y2)
    local r = math.atan2(y2 - y1, x2 - x1)
    return math.cos(r), math.sin(r)
end

local function isCloner(other)
    return other and other.itemType and other.itemType == "cloner"
end

local function newBody(self, x, y)
    
    local body = love.physics.newBody(g_World, x, y, "dynamic")
    local shape = love.physics.newCircleShape(16)
    local fixture = love.physics.newFixture(body, shape, 1)
    fixture:setUserData(self)
    
    return body
    
end


local Ball = {}
local mtBall = { __index=Ball }

function Ball.new(x, y)
    local self = setmetatable({}, mtBall)
    
    self.body = newBody(self, x or 0, y or x or 0)
    
    self.detectedCloners = setmetatable({}, { __mode='k' })
    
    self.multiplyAmount = 1
    
    return self
end

function Ball:update(dt)
    
    local dist = vector.dist(self.body:getX(), self.body:getY(), g_DestPoint.x, g_DestPoint.y) * 0.34
    
    local dirX, dirY = self:getDirToDestPoint()
    
    local forceX = dirX * dist * 200
    local forceY = dirY * dist * 200
    
    forceX, forceY = vector.trim(2500, forceX, forceY)
    
    local vx, vy = self.body:getLinearVelocity()
    self.body:applyForce(forceX - vx * 14, forceY - vy * 14)
    
    self:multiply()
end

function Ball:draw()
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), 16)
end

function Ball:destroy()
    self.body:destroy()
end

function Ball:beginContact(other)
    if not isCloner(other) then
        return
    end
    
    if self.detectedCloners[other] then
        return
    end
    
    self.detectedCloners[other] = true
    
    self.multiplyAmount = other.multiplyAmount
end

function Ball:multiply()
    if self.multiplyAmount == 1 then
        return
    end
    
    if self.multiplyAmount <= 0 then
        self._dead = true
        return
    end
    
    for i = 1, (self.multiplyAmount - 1) do
        
        local x = self.body:getX()
        local y = self.body:getY()
        
        if love.math.random() > 0.5 then
            x = x + 10
        else
            x = x - 10
        end
        
        local ball = Ball.new(x, y)
        
        for k, v in pairs(self.detectedCloners) do
            ball.detectedCloners[k] = true
        end
        
        g_Balls:add(ball)
    end
    
    self.multiplyAmount = 1
end

function Ball:getDirToDestPoint()
    return dirTo(self.body:getX(), self.body:getY(), g_DestPoint.x, g_DestPoint.y)
end

return Ball
