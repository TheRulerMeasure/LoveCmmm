-- destpoint --

local DestPoint = {}
local mtDestPoint = { __index=DestPoint }

function DestPoint.new(x, y)
    
    local self = setmetatable({}, mtDestPoint)
    
    self.x = x or 0
    self.y = y or x or 0
    
    return self
end

function DestPoint:update(dt)
    
    local speedX = 250
    local speedY = 75
    
    if love.keyboard.isDown('d') then
        
        self.x = self.x + speedX * dt
        
    elseif love.keyboard.isDown('a') then
        
        self.x = self.x - speedX * dt
        
    end
    
    self.y = self.y - speedY * dt
    
    g_Camera.y = self.y - 300
    
end

function DestPoint:draw()
    love.graphics.circle("line", self.x, self.y, 50, 50)
end

return DestPoint
