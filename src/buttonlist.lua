-- buttonlist --

local function drawCenterText(text, x, y, r, sx, sy)
    local font = love.graphics.getFont()
    local textWidth = font:getWidth(text)
    local textHeight = font:getHeight()
    
    love.graphics.print(text, x, y, r, sx, sy,
                        textWidth * 0.5,
                        textHeight * 0.5)
end


local ButtonList = {}
local mtButtonList = { __index=ButtonList }

function ButtonList.new(x, y, conf)
    local self = setmetatable({}, mtButtonList)
    
    self.x = x or 0
    self.y = y or x or 0
    
    self.buttons = {}
    
    for k, v in pairs(conf) do
        if type(k) == "number" then
            self.buttons[k] = v
        end
    end
    
    self.spacing = conf.spacing or 46
    
    self.curButtonIndex = conf.curButtonIndex or 1
    
    self.stickDelay = 0
    
    return self
end

function ButtonList:update(dt)
    
    local joysticks = love.joystick.getJoysticks()
    local j1 = joysticks[1]
    
    if j1 then
        local dir = j1:getAxis(2)
        
        if self.stickDelay <= 0 then
            if dir >= 0.5 then
                self:nextButton()
                self.stickDelay = 0.15
                
            elseif dir <= -0.5 then
                self:prevButton()
                self.stickDelay = 0.15
                
            end
        end
        
    end
    
    self.stickDelay = math.max(self.stickDelay - dt, 0)
end

function ButtonList:draw()
    
    love.graphics.setColor(1, 1, 1, 1)
    
    local patchWidth = 360
    local patchHeight = 48
    local x = self.x - patchWidth * 0.5
    local y = self.y - patchHeight * 0.5
    
    y = y + (self.curButtonIndex - 1) * self.spacing
    
    g_PatchPal:draw(x, y, patchWidth, patchHeight)
    
    for i, v in ipairs(self.buttons) do
        drawCenterText(v.name,
                        self.x,
                        self.y + (i - 1) * self.spacing)
    end
end

function ButtonList:keypressed(key)
    if key == "down" or key == 's' then
        self:nextButton()
    elseif key == "up" or key == 'w' then
        self:prevButton()
    elseif key == 'x' or key == "space" or key == "return" then
        self:buttonPress(self.curButtonIndex, "accept")
    elseif key == "right" or key == 'd' then
        self:buttonPress(self.curButtonIndex, "increase")
    elseif key == "left" or key == 'a' then
        self:buttonPress(self.curButtonIndex, "decrease")
    end
end

function ButtonList:gamepadpressed(joystick, button)
    if button == "dpdown" then
        self:nextButton()
    elseif button == "dpup" then
        self:prevButton()
    elseif button == 'a' then
        self:buttonPress(self.curButtonIndex, "accept")
    elseif button == "dpright" then
        self:buttonPress(self.curButtonIndex, "increase")
    elseif button == "dpleft" then
        self:buttonPress(self.curButtonIndex, "decrease")
    end
end

function ButtonList:nextButton()
    self.curButtonIndex = self.curButtonIndex + 1
    if self.curButtonIndex > #self.buttons then
        self.curButtonIndex = 1
    end
end

function ButtonList:prevButton()
    self.curButtonIndex = self.curButtonIndex - 1
    if self.curButtonIndex <= 0 then
        self.curButtonIndex = #self.buttons
    end
end

function ButtonList:buttonPress(n, funcType)
    local fn = self.buttons[n].fn
    
    if fn then
        fn(funcType)
    end
end

return ButtonList
