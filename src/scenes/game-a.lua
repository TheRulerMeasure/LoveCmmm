-- game-a --

local GobGroup = require "src.engines.gobgroup"

local RunnerGame = require "src.runnergame"

local Camera = require "src.camera"
local DestPoint = require "src.destpoint"


local function beginContact(a, b, coll)
    
    local dataA = a:getUserData()
    local dataB = b:getUserData()
    
    if dataA and dataA.beginContact then
        dataA:beginContact(dataB)
    end
    
    if dataB and dataB.beginContact then
        dataB:beginContact(dataA)
    end
    
end

local function endContact(a, b, coll)
    
    local dataA = a:getUserData()
    local dataB = b:getUserData()
    
    if dataA and dataA.endContact then
        dataA:endContact(dataB)
    end
    
    if dataB and dataB.endContact then
        dataB:endContact(dataA)
    end
    
end


return {
    arrive = function ()
        love.physics.setMeter(64)
        love.graphics.setBackgroundColor(0.78, 0.66, 0.65, 1)
        
        g_World = love.physics.newWorld(0, 0, true)
        g_World:setCallbacks(beginContact, endContact)
        
        g_RunnerGame = RunnerGame.new()
        g_Camera = Camera.new()
        g_Walls = GobGroup.new()
        g_TileLayers = {}
        g_Cloners = GobGroup.new()
        g_Counters = GobGroup.new()
        g_BallBads = GobGroup.new()
        g_Balls = GobGroup.new()
        g_BathBombs = GobGroup.new()
        g_DestPoint = DestPoint.new(0, 0)
        
        g_RunnerGame:initStage("ab")
    end,
    
    update = function (dt)
        g_World:update(dt)
        
        g_RunnerGame:update(dt)
        
        g_BathBombs:update(dt)
        
        g_BallBads:update(dt)
        g_Balls:update(dt)
        g_DestPoint:update(dt)
        
        g_Camera:update(dt)
    end,
    
    draw = function ()
        
        g_Camera:push()
            
            for i, layer in ipairs(g_TileLayers) do
                layer:draw()
            end
            g_BallBads:draw()
            g_Balls:draw()
            g_Cloners:draw()
            g_Counters:draw()
            g_BathBombs:draw()
            
            g_DestPoint:draw()
        
        love.graphics.pop()
    end,
    
    leave = function ()
        
        g_RunnerGame:destroy()
        g_RunnerGame = nil
        
        for i = #g_TileLayers, 1, -1 do
            table.remove(g_TileLayers, i)
        end
        g_TileLayers = nil
        
        g_BathBombs:destroy()
        g_BathBombs = nil
        
        g_Walls:destroy()
        g_Walls = nil
        g_BallBads:destroy()
        g_BallBads = nil
        g_Balls:destroy()
        g_Balls = nil
        g_Cloners:destroy()
        g_Cloners = nil
        g_Counters:destroy()
        g_Counters = nil
        g_World:destroy()
        g_World = nil
        
        g_Camera = nil
        
        g_DestPoint = nil
    end,
    
    keypressed = function (key, scancode, isrepeat)
        
    end,
}
