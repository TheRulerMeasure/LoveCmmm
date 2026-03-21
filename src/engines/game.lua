-- game --


local function callMethod(target, method, ...)
    if target[method] then
        target[method](...)
    end
end


local Game = {}
local mtGame = { __index=Game }

function Game.new(initialScene, scenes)
    local self = setmetatable({
        
        fixedTimeStep = 1 / 60,
        maxFrameTime = 0.25,
        accumulator = 0,
        
        nextScene = nil,
        sceneData = nil,
        
    }, mtGame)
    
    self.scenes = scenes
    
    self.curScene = self.scenes[initialScene]
    callMethod(self.curScene, "arrive")
    
    return self
end

function Game:update(dt)
    local frameTime = math.min(dt, self.maxFrameTime)
    self.accumulator = self.accumulator + frameTime
    local fixed = self.fixedTimeStep
    while self.accumulator >= fixed do
        self.accumulator = self.accumulator - fixed
        self:fixedUpdate(fixed)
    end
end

function Game:fixedUpdate(dt)
    callMethod(self.curScene, "update", dt)
    
    self:sceneTransit()
end

function Game:draw()
    callMethod(self.curScene, "draw")
end

function Game:keypressed(key, scancode, isrepeat)
    callMethod(self.curScene, "keypressed", key, scancode, isrepeat)
end

function Game:sceneTransit()
    if not self.nextScene then
        return
    end
    
    callMethod(self.curScene, "leave")
    self.curScene = self.scenes[self.nextScene]
    callMethod(self.curScene, "arrive", self.sceneData)
    
    self.nextScene = nil
    self.sceneData = nil
end

function Game:setNextScene(nextScene, sceneData)
    self.nextScene = nextScene
    self.sceneData = sceneData
end

return Game
