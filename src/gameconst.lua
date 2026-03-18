-- gameconst --

local CANVAS_WIDTH = 800,
local CANVAS_HEIGHT = 600,

local function getCenterXY()
    return CANVAS_WIDTH * 0.5, CANVAS_HEIGHT * 0.5
end

return {
    CANVAS_WIDTH = CANVAS_WIDTH,
    CANVAS_HEIGHT = CANVAS_HEIGHT,
    
    getCenterXY=getCenterXY,
}
