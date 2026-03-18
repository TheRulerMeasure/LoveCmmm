-- menu --

return {
    arrive = function (self)
        
    end,
    
    update = function (self, dt)
        
    end,
    
    draw = function (self)
        love.graphics.print("Welcome to Menu!")
    end,
    
    leave = function (self)
        
    end,
    
    keypressed = function (self, key, scancode, isrepeat)
        if key == 'd' then
            g_Game:setNextScene("game_a")
        end
    end,
}
