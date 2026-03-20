-- ballbad --

local BathBomb = require "src.bathbomb"

local BALL_RADIUS = 10
local SENSOR_RADIUS = 278

local COLOR_BAD = { 0.77, 0.15, 0.15, 1 }


local function dirTo(x1, y1, x2, y2)
    local r = math.atan2(y2 - y1, x2 - x1)
    return math.cos(r), math.sin(r)
end

local function isEnemy(other)
    return other and other.teamGood
end

local function newBody(self, x, y)
    
    local body = love.physics.newBody(g_World, x, y, "dynamic")
    local shape = love.physics.newCircleShape(BALL_RADIUS)
    local fixture = love.physics.newFixture(body, shape, 1)
    fixture:setUserData(self)
    
    return body
    
end

local function newBodySensor(self, x, y)
    
    local body = love.physics.newBody(g_World, x, y, "dynamic")
    local shape = love.physics.newCircleShape(SENSOR_RADIUS)
    local fixture = love.physics.newFixture(body, shape)
    
    fixture:setUserData(self)
    fixture:setSensor(true)
    
    return body
    
end

local function sensorDestroy(self)
    self.body:destroy()
end

local function sensorBeginContact(self, other)
    
    if not isEnemy(other) then
        return
    end
    
    self.detectedEnemies[other] = true
    
end

local function sensorEndContact(self, other)
    
    if not isEnemy(other) then
        return
    end
    
    self.detectedEnemies[other] = nil
    
end

local function sensorSetXY(self, x, y)
    
    self.body:setX(x)
    self.body:setY(y)
    
end

local function sensorGetDetectedEnemies(self)
    local t = {}
    local i = 0
    for enemy, v in pairs(self.detectedEnemies) do
        i = i + 1
        t[i] = enemy
    end
    return t
end

local function sensorGetDetectedEnemy(self)
    for enemy, v in pairs(self.detectedEnemies) do
        return enemy
    end
end

local function newSensor(x, y)
    
    local self = {}
    
    self.destroy = sensorDestroy
    self.beginContact = sensorBeginContact
    self.endContact = sensorEndContact
    self.setXY = sensorSetXY
    self.getDetectedEnemies = sensorGetDetectedEnemies
    self.getDetectedEnemy = sensorGetDetectedEnemy
    
    self.body = newBodySensor(self, x, y)
    
    self.detectedEnemies = setmetatable({}, { __mode='k' })
    
    return self
    
end


local Ball = {}
local mtBall = { __index=Ball }

function Ball.new(x, y, speed)
    
    local x = x or 0
    local y = y or x or 0
    
    local self = setmetatable({}, mtBall)
    
    self.speed = speed or 500
    self.body = newBody(self, x, y)
    
    self.sensor = newSensor(x, y)
    
    self.animTime = 0
    self.sprFacingRight = true
    
    return self
end

function Ball:update(dt)
    
    self.sensor:setXY(self.body:getX(), self.body:getY())
    
    local dirX = 0
    local dirY = 0
    
    local enemy = self.sensor:getDetectedEnemy()
    if enemy then
        dirX, dirY = dirTo(self.body:getX(), self.body:getY(),
                            enemy.body:getX(), enemy.body:getY())
    end
    
    
    local mass = self.body:getMass()
    
    local forceX = dirX * mass * self.speed
    local forceY = dirY * mass * self.speed
    
    local vx, vy = self.body:getLinearVelocity()
    forceX = forceX - vx * mass * 7
    forceY = forceY - vy * mass * 7
    self.body:applyForce(forceX, forceY)
    
    self.animTime = self.animTime + dt
    
    if vx > 50 then
        self.sprFacingRight = true
    elseif vx < -50 then
        self.sprFacingRight = false
    end
end

function Ball:draw()
    love.graphics.setColor(COLOR_BAD)
    
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
    self.sensor:destroy()
    self.body:destroy()
end

function Ball:beginContact(other)
    if not isEnemy(other) then
        return
    end
    
    self._dead = true
    other._dead = true
    
    local bomb = BathBomb.new(other.body:getX(),
                                other.body:getY(),
                                {
                                    bombType = "cloud",
                                    
                                    color = { 0.7, 0.7, 0.7, 0.45 },
                                })
    
    g_BathBombs:add(bomb)
end

return Ball
