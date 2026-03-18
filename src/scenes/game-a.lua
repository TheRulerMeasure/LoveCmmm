-- game-a --

local Camera = require "src.camera"

local Ball = require "src.ball"
local DestPoint = require "src.destpoint"

return {
    arrive = function ()
        love.physics.setMeter(64)
        
        g_Camera = Camera.new()
        
        g_World = love.physics.newWorld(0, 0, true)
        
        g_Balls = {}
        
        g_DestPoint = DestPoint.new(400, 600)
        
        for i = 1, 2 do
            g_Balls[i] = Ball.new(250 + (i - 1) * 36, 600)
        end
        
    end,
    
    update = function (dt)
        g_World:update(dt)
        
        for i, ball in ipairs(g_Balls) do
            ball:update(dt)
        end
        
        g_DestPoint:update(dt)
    end,
    
    draw = function ()
        
        g_Camera:push()
        
            for i, ball in ipairs(g_Balls) do
                ball:draw()
            end
            
            g_DestPoint:draw()
        
        love.graphics.pop()
    end,
    
    leave = function ()
        
        g_Camera = nil
        
        for i, ball in ipairs(g_Balls) do
            ball:destroy()
        end
        g_Balls = nil
        
        g_World:destroy()
        g_World = nil
        
        g_DestPoint = nil
    end,
    
    keypressed = function (key, scancode, isrepeat)
        
    end,
}
