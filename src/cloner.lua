-- cloner --


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


local function newBody(x, y, width, height, multiplyAmount)
    
    local body = love.physics.newBody(g_World, x, y, "static")
    local shape = love.physics.newPolygonShape(0, 0, width, 0, width, height, 0, height)
    local fixture = love.physics.newFixture(body, shape)
    
    fixture:setSensor(true)
    fixture:setUserData({ itemType="cloner", multiplyAmount=multiplyAmount })
    
    return body
    
end


local Cloner = {}
local mtCloner = { __index=Cloner }

function Cloner.new(x, y, width, height, multiplyAmount)
    
    local self = setmetatable({}, mtCloner)
    
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    
    self.multiplyAmount = multiplyAmount or 2
    
    self.color = (self.multiplyAmount == 0) and { 0.7, 0.1, 0.1, 0.7 } or { 0.5, 0.5, 0.7, 0.6 }
    
    self.body = newBody(self.x,
                        self.y,
                        self.width,
                        self.height,
                        self.multiplyAmount)
    
    return self
    
end

function Cloner:draw()
    
    love.graphics.setColor(self.color)
    g_PatchPal:draw(self.x, self.y, self.width, self.height)
    
    love.graphics.setColor(1, 1, 1, 1)
    drawTextCenter("x" .. self.multiplyAmount,
                    self.x + self.width * 0.5,
                    self.y + self.height * 0.5)
    
end

function Cloner:destroy()
    self.body:destroy()
end

return Cloner
