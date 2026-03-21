-- main --

-- music https://opengameart.org/content/time-to-puzzle-it-up

local newSpriteSheet = require "src.engines.spritesheet"
local newSpritePatch = require "src.engines.spritepatch"

local Game = require "src.engines.game"


function love.load()
    
    g_SprSaa = newSpriteSheet("assets/textures/saa_tt_sheet.png", 7, 2)
    g_SprAnt = newSpriteSheet("assets/textures/ant_sheet.png", 2, 1)
    g_SprCloud = newSpriteSheet("assets/textures/cloud.png")
    g_SprStar = newSpriteSheet("assets/textures/star.png")
    g_PatchPal = newSpritePatch("assets/textures/pal.png", {
        left = 16,
        right = 16,
        top = 16,
        bottom = 16,
    })
    
    g_MusicPuzzle = love.audio.newSource("assets/music/time to puzzle_Master.ogg", "stream")
    g_MusicPuzzle:setLooping(true)
    
    g_TilesetSaa = require("assets/textures/saa_tt_sheet")
    
    local font = love.graphics.newFont("assets/textures/pmpaact_sheet_sized export.fnt")
    love.graphics.setFont(font)
    
    g_Data = {
        
        musicVolume = 1,
        
        setMusicVolume = function (self, v)
            self.musicVolume = math.min(math.max(math.floor(v), 0), 10)
            g_MusicPuzzle:setVolume(self.musicVolume * 0.1)
        end,
        
        getActualMusicVolume = function (self)
            return self.musicVolume * 0.1
        end,
        
        curSelectedLevel = 1,
        
        levels = {},
    }
    for i = 1, 8 do
        g_Data.levels[i] = { count=0 }
    end
    
    g_MusicPuzzle:setVolume(g_Data:getActualMusicVolume())
    
    g_Game = Game.new("option", {
        
        ["option"] = require("src/scenes/option"),
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
