-- main --

local newSpriteSheet = require "src.engines.spritesheet"
local newSpritePatch = require "src.engines.spritepatch"

local Game = require "src.engines.game"

function love.load()
    
    g_SprSaa = newSpriteSheet("assets/textures/saa_tt_sheet.png", 7, 2)
    g_PatchPal = newSpritePatch("assets/textures/pal.png", {
        left = 16,
        right = 16,
        top = 16,
        bottom = 16,
    })
    
    g_TilesetSaa = require("assets/textures/saa_tt_sheet")
    
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
