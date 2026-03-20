-- ball --

local BathBomb = require "src.bathbomb"

local BALL_RADIUS = 10

local COLOR_GOOD = { 0.605, 0.6, 0.95, 1 }

local SPEED = 1500


local function dirTo(x1, y1, x2, y2)
    local r = math.atan2(y2 - y1, x2 - x1)
    return math.cos(r), math.sin(r)
end

local function isCloner(other)
    return other and other.itemType and other.itemType == "cloner"
end

local function newBody(self, x, y)
    
    local body = love.physics.newBody(g_World, x, y, "dynamic")
    local shape = love.physics.newCircleShape(BALL_RADIUS)
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
    
    self.animTime = 0
    self.sprFacingRight = true
    
    self.teamGood = true
    
    return self
end

function Ball:update(dt)
    
    local mass = self.body:getMass()
    
    local dirX, dirY = self:getDirToDestPoint()
    
    local forceX = dirX * mass * SPEED
    local forceY = dirY * mass * SPEED
    
    local vx, vy = self.body:getLinearVelocity()
    forceX = forceX - vx * mass * 7
    forceY = forceY - vy * mass * 7
    self.body:applyForce(forceX, forceY)
    
    self:multiply()
    
    self.animTime = self.animTime + dt
    
    if vx > 50 then
        self.sprFacingRight = true
    elseif vx < -50 then
        self.sprFacingRight = false
    end
end

function Ball:draw()
    love.graphics.setColor(COLOR_GOOD)
    
    local frame = (math.floor(self.animTime * 8) % 2) + 1
    
    local sx = self.sprFacingRight and 1 or -1
    
    g_SprAnt:drawCenter(frame,
                        self.body:getX(),
                        self.body:getY(),
                        0,
                        sx,
                        1)
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
        
        self:putBallAt(x, y)
    end
    
    self.multiplyAmount = 1
end

function Ball:putBallAt(x, y)
    
    local ball = Ball.new(x, y)
    for k, v in pairs(self.detectedCloners) do
        ball.detectedCloners[k] = true
    end
    g_Balls:add(ball)
    
    local bomb = BathBomb.new(ball.body:getX(),
                                ball.body:getY(),
                                {
                                    amount = 6,
                                    
                                    minSpeed = 400,
                                    maxSpeed = 400,
                                    
                                    minLifeTime = 0.2,
                                    maxLifeTime = 0.23,
                                    
                                    minRotateSpeed = 0,
                                    maxRotateSpeed = 0,
                                    
                                    color = { 0.8, 0.7, 1, 1 },
                                })
    
    g_BathBombs:add(bomb)
    
end

function Ball:getDirToDestPoint()
    return dirTo(self.body:getX(), self.body:getY(), g_DestPoint.x, g_DestPoint.y)
end

return Ball
