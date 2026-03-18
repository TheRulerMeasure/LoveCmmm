-- ball --

local vector = require "lib.vector-light"


local function dirTo(x1, y1, x2, y2)
    local r = math.atan2(y2 - y1, x2 - x1)
    return math.cos(r), math.sin(r)
end

local function newBody(x, y)
    
    local body = love.physics.newBody(g_World, x, y, "dynamic")
    local shape = love.physics.newCircleShape(16)
    love.physics.newFixture(body, shape, 1)
    
    return body
    
end


local Ball = {}
local mtBall = { __index=Ball }

function Ball.new(x, y)
    local self = setmetatable({}, mtBall)
    
    self.body = newBody(x or 0, y or x or 0)
    
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
    
end

function Ball:draw()
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), 16)
end

function Ball:destroy()
    self.body:destroy()
end

function Ball:getDirToDestPoint()
    return dirTo(self.body:getX(), self.body:getY(), g_DestPoint.x, g_DestPoint.y)
end

return Ball
