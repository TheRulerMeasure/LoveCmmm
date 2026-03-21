-- destpoint --

local LIMIT_LEFT = 64
local LIMIT_RIGHT = 704

local DestPoint = {}
local mtDestPoint = { __index=DestPoint }

function DestPoint.new(x, y)
    
    local self = setmetatable({}, mtDestPoint)
    
    self.x = x or 0
    self.y = y or x or 0
    
    self.topReached = false
    
    return self
end

function DestPoint:update(dt)
    
    local speedX = 250
    local speedY = 106
    
    if love.keyboard.isDown('d', "right") then
        self.x = math.min(self.x + speedX * dt, LIMIT_RIGHT)
    elseif love.keyboard.isDown('a', "left") then
        self.x = math.max(self.x - speedX * dt, LIMIT_LEFT)
    end
    
    self.y = self.y - speedY * dt
    
    
    
    local counter = g_Counters.gobs[1]
    if counter then
        
        if self.y >= counter.y then
            g_Camera.y = self.y - 400
        end
        
        if self.y < counter.y - 450 then
            self.topReached = true
        end
    else
        g_Camera.y = self.y - 400
    end
    
end

function DestPoint:draw()
    love.graphics.setColor(0.6, 1, 0.21, 1)
    love.graphics.circle("line", self.x, self.y, 50, 50)
end

return DestPoint
