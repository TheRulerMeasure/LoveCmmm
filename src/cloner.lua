-- cloner --


local function newBody(x, y, width, height)
    
    local body = love.physics.newBody(g_World, x, y, "static")
    local shape = love.physics.newPolygonShape(0, 0, width, 0, width, height, 0, height)
    local fixture = love.physics.newFixture(body, shape)
    
    fixture:setSensor(true)
    fixture:setUserData({ itemType="cloner" })
    
    return body
    
end


local Cloner = {}
local mtCloner = { __index=Cloner }

function Cloner.new(x, y, width, height)
    
    local self = setmetatable({}, mtCloner)
    
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    
    self.body = newBody(self.x, self.y, self.width, self.height)
    
    return self
    
end

function Cloner:draw()
    
    g_PatchPal:draw(self.x, self.y, self.width, self.height)
    
end

function Cloner:destroy()
    self.body:destroy()
end

return Cloner
