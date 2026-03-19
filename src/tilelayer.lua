-- tilelayer --


local TileLayer = {}
local mtTileLayer = { __index=TileLayer }

function TileLayer.new(layer, tileWidth, tileHeight)
    local self = setmetatable({}, mtTileLayer)
    
    self.data = layer.data
    self.width = layer.width
    
    self.tileWidth = tileWidth or 64
    self.tileHeight = tileHeight or 64
    
    return self
end

function TileLayer:draw()
    
    for i, tile in ipairs(self.data) do
        
        if tile > 0 then
            
            local cx = (i - 1) % self.width
            local cy = math.floor((i - 1) / self.width)
            
            g_SprSaa:draw(tile, cx * self.tileWidth, cy * self.tileHeight)
            
        end
    end
end

return TileLayer
