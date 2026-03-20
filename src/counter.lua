-- counter --

local function drawTextCenter(text, x, y)
    
    local font = love.graphics.getFont()
    local textWidth = font:getWidth(text)
    local textHeight = font:getHeight()
    love.graphics.print(text,
                        x,
                        y,
                        0,
                        1,
                        1,
                        textWidth * 0.5,
                        textHeight * 0.5)
    
end

local function isBall(other)
    return other and other.teamGood
end

local function newBody(self, x, y, width, height)
    
    local body = love.physics.newBody(g_World, x, y, "static")
    local shape = love.physics.newPolygonShape(0, 0, width, 0, width, height, 0, height)
    local fixture = love.physics.newFixture(body, shape)
    
    fixture:setSensor(true)
    fixture:setUserData(self)
    
    return body
    
end

local Counter = {}
local mtCounter = { __index=Counter }

function Counter.new(x, y, width, height)
    
    local self = setmetatable({}, mtCounter)
    
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    
    self.body = newBody(self, self.x, self.y, self.width, self.height)
    
    self.detectedBalls = setmetatable({}, { __mode='k' })
    self.ballCount = 0
    
    return self
    
end

function Counter:draw()
    
    love.graphics.setColor(0.6, 1, 0.62, 0.6)
    g_PatchPal:draw(self.x, self.y, self.width, self.height)
    
    love.graphics.setColor(1, 1, 1, 1)
    drawTextCenter(self.ballCount,
                    self.x + self.width * 0.5,
                    self.y + self.height * 0.5)
    
end

function Counter:destroy()
    self.body:destroy()
end

function Counter:beginContact(other)
    
    if not isBall(other) then
        return
    end
    
    if self.detectedBalls[other] then
        return
    end
    
    self.detectedBalls[other] = true
    
    self.ballCount = self.ballCount + 1
    
end

return Counter
