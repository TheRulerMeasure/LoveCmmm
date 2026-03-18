-- main --

local Game = require "src.engines.game"

function love.load()
    g_Game = Game.new("game_a", {
        
        ["menu"] = require("src/scenes/menu"),
        ["game_a"] = require("src/scenes/game-a"),
        
    })
end

function love.update(dt)
    g_Game:update(dt)
end

function love.draw()
    g_Game:draw()
end

function love.keypressed(key, scancode, isrepeat)
    g_Game:keypressed(key, scancode, isrepeat)
end
