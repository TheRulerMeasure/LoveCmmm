-- spritepatch --

local Patch = {}
local mtPatch = { __index=Patch }

function Patch.new(filepath, config)
    
    local conf = config or {}
    
    local self = setmetatable({}, mtPatch)
    
    self.img = love.graphics.newImage(filepath)
    
    self.leftWidth = conf.left or 16
    self.rightWidth = conf.right or 16
    self.topWidth = conf.top or 16
    self.bottomWidth = conf.bottom or 16
    
    self.quads = {}
    
    local sw = self.img:getWidth()
    local sh = self.img:getHeight()
    
    self.quads[1] = love.graphics.newQuad(0,
                                            0,
                                            self.leftWidth,
                                            self.topWidth,
                                            sw, sh)
    
    self.quads[2] = love.graphics.newQuad(self.leftWidth,
                                            0,
                                            sw - self.leftWidth - self.rightWidth,
                                            self.topWidth,
                                            sw, sh)
    
    self.quads[3] = love.graphics.newQuad(sw - self.rightWidth,
                                            0,
                                            self.rightWidth,
                                            self.topWidth,
                                            sw, sh)
    
    self.quads[4] = love.graphics.newQuad(0,
                                            self.topWidth,
                                            self.leftWidth,
                                            sh - self.topWidth - self.bottomWidth,
                                            sw, sh)
    
    self.quads[5] = love.graphics.newQuad(self.leftWidth,
                                            self.topWidth,
                                            sw - self.leftWidth - self.rightWidth,
                                            sh - self.topWidth - self.bottomWidth,
                                            sw, sh)
    
    self.quads[6] = love.graphics.newQuad(sw - self.rightWidth,
                                            self.topWidth,
                                            self.rightWidth,
                                            sh - self.topWidth - self.bottomWidth,
                                            sw, sh)
    
    self.quads[7] = love.graphics.newQuad(0,
                                            sh - self.bottomWidth,
                                            self.leftWidth,
                                            self.bottomWidth,
                                            sw, sh)
    
    self.quads[8] = love.graphics.newQuad(self.leftWidth,
                                            sh - self.bottomWidth,
                                            sw - self.leftWidth - self.rightWidth,
                                            self.bottomWidth,
                                            sw, sh)
    
    self.quads[9] = love.graphics.newQuad(sw - self.rightWidth,
                                            sh - self.bottomWidth,
                                            self.rightWidth,
                                            self.bottomWidth,
                                            sw, sh)
    
    
    return self
    
end

function Patch:draw(x, y, width, height)
    
    local x = x or 0
    local y = y or 0
    local width = width or 64
    local height = height or 64
    
    local offh = self.leftWidth + self.rightWidth
    local offv = self.topWidth + self.bottomWidth
    
    local sx = (width - offh) / (self.img:getWidth() - offh)
    local sy = (height - offv) / (self.img:getHeight() - offv)
    
    love.graphics.draw(self.img,self.quads[1], x, y)
    love.graphics.draw(self.img, self.quads[2], x + self.leftWidth, y, 0, sx, 1)
    love.graphics.draw(self.img, self.quads[3], x + (width - self.rightWidth), y)
    love.graphics.draw(self.img, self.quads[4], x, y + self.topWidth, 0, 1, sy)
    love.graphics.draw(self.img, self.quads[5], x + self.leftWidth, y + self.topWidth, 0, sx, sy)
    love.graphics.draw(self.img, self.quads[6], x + (width - self.rightWidth), y + self.topWidth, 0, 1, sy)
    love.graphics.draw(self.img, self.quads[7], x, y + (height - self.bottomWidth))
    love.graphics.draw(self.img, self.quads[8], x + self.leftWidth, y + (height - self.bottomWidth), 0, sx, 1)
    love.graphics.draw(self.img, self.quads[9], x + (width - self.rightWidth), y + (height - self.bottomWidth))
    
end

return function (filepath, config)
    return Patch.new(filepath, config)
end
