-- option --

return {
    arrive = function ()
        
        g_Adjusted = false
        
        love.graphics.setBackgroundColor(0.78, 0.66, 0.65, 1)
        
        g_MusicPuzzle:play()
    end,
    
    update = function (dt)
        
    end,
    
    draw = function ()
        
        love.graphics.print("Press W/S\nto change the Volume.", 50, 200)
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("BGM: " .. g_Data:getActualMusicVolume(), 100, 400)
        
        if g_Adjusted then
            love.graphics.print("Press Space when done.", 50, 604)
        end
    end,
    
    leave = function ()
        
        g_Adjusted = nil
        
    end,
    
    keypressed = function (key)
        
        if key == "up" or key == 'w' then
            g_Data:setMusicVolume(g_Data.musicVolume + 1)
            
            g_Adjusted = true
            
        elseif key == "down" or key == 's' then
            g_Data:setMusicVolume(g_Data.musicVolume - 1)
            
            g_Adjusted = true
            
        elseif key == "space" or key == 'x' then
            
            if g_Adjusted then
                g_Game:setNextScene("menu")
            end
            
        end
        
    end,
}
