-- game-a --

local RunnerGame = require "src.runnergame"

local Camera = require "src.camera"
local DestPoint = require "src.destpoint"


local function checkBallClonerContact(a, b)
    
end


local function beginContact(a, b, coll)
    
    local dataA = a:getUserData()
    local dataB = b:getUserData()
    
    if dataA and dataA.beginContact then
        dataA.beginContact(dataB)
    end
    
    if dataB and dataB.beginContact then
        dataB.beginContact(dataA)
    end
    
end

local function endContact(a, b, coll)
    
    
    
end


return {
    arrive = function ()
        love.physics.setMeter(64)
        love.graphics.setBackgroundColor(0.78, 0.66, 0.65, 1)
        
        g_World = love.physics.newWorld(0, 0, true)
        g_World:setCallbacks(beginContact, endContact)
        
        g_RunnerGame = RunnerGame.new()
        g_Camera = Camera.new()
        g_Walls = {}
        g_TileLayers = {}
        g_Cloners = {}
        g_Balls = {}
        g_DestPoint = DestPoint.new(0, 0)
        
        g_RunnerGame:initStage("ab")
    end,
    
    update = function (dt)
        g_World:update(dt)
        
        for i, ball in ipairs(g_Balls) do
            ball:update(dt)
        end
        
        g_DestPoint:update(dt)
        
        g_Camera:update(dt)
    end,
    
    draw = function ()
        
        g_Camera:push()
            
            for i, layer in ipairs(g_TileLayers) do
                layer:draw()
            end
            for i, ball in ipairs(g_Balls) do
                ball:draw()
            end
            for i, c in ipairs(g_Cloners) do
                c:draw()
            end
            g_DestPoint:draw()
        
        love.graphics.pop()
    end,
    
    leave = function ()
        
        for i = #g_Walls, 1, -1 do
            g_Walls[i]:destroy()
            table.remove(g_Walls, i)
        end
        g_Walls = nil
        
        for i = #g_TileLayers, 1, -1 do
            table.remove(g_TileLayers, i)
        end
        g_TileLayers = nil
        
        for i = #g_Balls, 1, -1 do
            g_Balls[i]:destroy()
            table.remove(g_Balls, i)
        end
        g_Balls = nil
        
        for i = #g_Cloners, 1, -1 do
            g_Cloners[i]:destroy()
            table.remove(g_Cloners, i)
        end
        g_Cloners = nil
        
        g_World:destroy()
        g_World = nil
        
        g_Camera = nil
        
        g_DestPoint = nil
    end,
    
    keypressed = function (key, scancode, isrepeat)
        
    end,
}
