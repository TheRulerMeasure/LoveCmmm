-- math2 --

local function randRange(minv, maxv)
    return love.math.random() * (maxv - minv) + minv
end

return {
    randRange=randRange,
}
