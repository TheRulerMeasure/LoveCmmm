-- gobgroup --

local Group = {}
local mtGroup = { __index=Group }

function Group.new()
    
    local self = setmetatable({}, mtGroup)
    
    self.gobs = {}
    
    return self
end

function Group:update(dt)
    
    local deads = {}
    
    for i, gob in ipairs(self.gobs) do
        if gob.update then
            gob:update(dt)
        end
        if gob._dead then
            table.insert(deads, i)
        end
    end
    
    for i = #deads, 1, -1 do
        local gob = self.gobs[deads[i]]
        table.remove(self.gobs, deads[i])
        if gob.destroy then
            gob:destroy()
        end
    end
    
end

function Group:draw()
    
    for i, gob in ipairs(self.gobs) do
        if gob.draw then
            gob:draw()
        end
    end
    
end

function Group:destroy()
    
    for i = #self.gobs, 1, -1 do
        local gob = self.gobs[i]
        table.remove(self.gobs, i)
        if gob.destroy then
            gob:destroy()
        end
    end
    
end

function Group:add(newGob)
    table.insert(self.gobs, newGob)
end

return Group
