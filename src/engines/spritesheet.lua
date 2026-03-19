-- spritesheet --

local SP = {}
local mtSP = { __index=SP }

function SP:draw(frame, x, y, r, sx, sy)
    love.graphics.draw(self.img, self.quads[frame], x, y, r, sx, sy)
end

function SP:drawCenter(frame, x, y, r, sx, sy)
    love.graphics.draw(self.img, self.quads[frame], x, y, r, sx, sy, self.width * 0.5, self.height * 0.5)
end

return function (imgpath, hframes, vframes, settings)
    local hf = math.max(hframes or 1, 1)
    local vf = math.max(vframes or 1, 1)
    
    local img = love.graphics.newImage(imgpath, settings)
    
    local imgWidth = img:getWidth()
    local imgHeight = img:getHeight()
    
    local quadWidth = math.floor(imgWidth / hf)
    local quadHeight = math.floor(imgHeight / vf)
    
    local quads = {}
    
    if hf == 1 and vf == 1 then
        table.insert(quads,
                    love.graphics.newQuad(0,
                                            0,
                                            quadWidth,
                                            quadHeight,
                                            imgWidth,
                                            imgHeight))
    else
        for i = 1, (hf * vf) do
            local x = (i-1) % hf
            x = x * quadWidth
            local y = math.floor((i-1) / hf)
            y = y * quadHeight
            table.insert(quads,
                        love.graphics.newQuad(x,
                                                y,
                                                quadWidth,
                                                quadHeight,
                                                imgWidth,
                                                imgHeight))
        end
    end
    
    
    return setmetatable({
        img = img,
        
        quads = quads,
        
        hframes = hf,
        vframes = vf,
        
        width = quadWidth,
        height = quadHeight,
        
    }, mtSP)
end
