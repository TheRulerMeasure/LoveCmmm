-- camera --

local Camera = {}
local mtCamera = { __index=Camera }

function Camera.new(x, y)
    local self = setmetatable({}, mtCamera)
    
    self.x = x or 0
    self.y = y or x or 0
    
    return self
end

function Camera:update(dt)
    
end

function Camera:push()
    love.graphics.push()
    love.graphics.translate(-self.x, -self.y)
end

return Camera
