-- menu --

local gconst = require "src.gameconst"

local ButtonList = require "src.buttonlist"

return {
    arrive = function (sceneData)
        
        love.graphics.setBackgroundColor(0.78, 0.66, 0.65, 1)
        
        g_ButtonList = ButtonList.new(gconst.CANVAS_WIDTH * 0.5, 200, {
            
            {
                name = "LEVEL 1 " .. g_Data.levels[1].count,
                
                fn = function (ftype)
                    if ftype == "accept" then
                        g_Game:setNextScene("game_a", { mapname="ac", level=1, showTutorial=true })
                        g_Data.curSelectedLevel = 1
                    end
                end,
            },
            {
                name = "LEVEL 2 " .. g_Data.levels[2].count,
                
                fn = function (ftype)
                    if ftype == "accept" then
                        g_Game:setNextScene("game_a", { mapname="ad", level=2 })
                        g_Data.curSelectedLevel = 2
                    end
                end,
            },
            {
                name = "LEVEL 3 " .. g_Data.levels[3].count,
                
                fn = function (ftype)
                    if ftype == "accept" then
                        g_Game:setNextScene("game_a", { mapname="af", level=3 })
                        g_Data.curSelectedLevel = 3
                    end
                end,
            },
            {
                name = "LEVEL 4 " .. g_Data.levels[4].count,
                
                fn = function (ftype)
                    if ftype == "accept" then
                        g_Game:setNextScene("game_a", { mapname="ag", level=4 })
                        g_Data.curSelectedLevel = 4
                    end
                end,
            },
            {
                name = "LEVEL 5 " .. g_Data.levels[5].count,
                
                fn = function (ftype)
                    if ftype == "accept" then
                        g_Game:setNextScene("game_a", { mapname="ah", level=5 })
                        g_Data.curSelectedLevel = 5
                    end
                end,
            },
            {
                name = "LEVEL 6 " .. g_Data.levels[6].count,
                
                fn = function (ftype)
                    if ftype == "accept" then
                        g_Game:setNextScene("game_a", { mapname="ai", level=6 })
                        g_Data.curSelectedLevel = 6
                    end
                end,
            },
            {
                name = "LEVEL 7 " .. g_Data.levels[7].count,
                
                fn = function (ftype)
                    if ftype == "accept" then
                        g_Game:setNextScene("game_a", { mapname="aj", level=7 })
                        g_Data.curSelectedLevel = 7
                    end
                end,
            },
            {
                name = "LEVEL 8 " .. g_Data.levels[8].count,
                
                fn = function (ftype)
                    if ftype == "accept" then
                        g_Game:setNextScene("game_a", { mapname="ak", level=8 })
                        g_Data.curSelectedLevel = 8
                    end
                end,
            },
            
            curButtonIndex = g_Data.curSelectedLevel,
        })
        
        g_MusicPuzzle:stop()
        g_MusicPuzzle:play()
    end,
    
    update = function (dt)
        g_ButtonList:update(dt)
    end,
    
    draw = function ()
        g_ButtonList:draw()
    end,
    
    leave = function ()
        g_ButtonList = nil
    end,
    
    keypressed = function (key, scancode, isrepeat)
        g_ButtonList:keypressed(key)
    end,
}
