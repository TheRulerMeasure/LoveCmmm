-- runnergame --

local gconst = require "src.gameconst"

local Ball = require "src.ball"
local Cloner = require "src.cloner"
local TileLayer = require "src.tilelayer"

local TILE_WALL = 8
local TILE_WIDTH = 64
local TILE_HEIGHT = 64


local function unpackPolygon(polygon)
    
    local verts = {}
    
    local n = 0
    
    for i, p in ipairs(polygon) do
        n = n + 1
        verts[n] = p.x
        n = n + 1
        verts[n] = p.y
    end
    
    return verts
    
end


local RunnerGame = {}
local mtRunnerGame = { __index=RunnerGame }

function RunnerGame.new()
    
    local self = setmetatable({}, mtRunnerGame)
    return self
    
end

function RunnerGame:initStage(mapname)
    
    local map = require("maps/" .. mapname)
    
    for i, layer in ipairs(map.layers) do
        self:parseTileLayer(layer, map.tilewidth, map.tileheight)
    end
    
end

function RunnerGame:parseTileLayer(layer, tileWidth, tileHeight)
    
    if layer.type == "group" then
        
        for i, l in ipairs(layer.layers) do
            self:parseTileLayer(l, tileWidth, tileHeight)
        end
        
    elseif layer.type == "tilelayer" then
        
        for i, tile in ipairs(layer.data) do
            
            local x = ((i - 1) % layer.width) * tileWidth
            local y = math.floor((i - 1) / layer.width) * tileHeight
            
            self:parseTile(tile, x, y)
        end
        table.insert( g_TileLayers, TileLayer.new(layer, tileWidth, tileHeight) )
        
    elseif layer.type == "objectgroup" then
        
        for i, o in ipairs(layer.objects) do
            self:parseObject(o)
        end
        
    end
    
end

function RunnerGame:parseTile(tile, x, y)
    
    for i, tt in ipairs(g_TilesetSaa.tiles) do
        if (tile - 1) == tt.id then
            
            for j, o in ipairs(tt.objectGroup.objects) do
                
                local body = love.physics.newBody(g_World, x + o.x, y + o.y, "static")
                local shape = love.physics.newPolygonShape(unpackPolygon(o.polygon))
                love.physics.newFixture(body, shape)
                
                g_Walls:add(body)
                
            end
            
            break
        end
    end
end

function RunnerGame:parseObject(o)
    
    if o.type == "point_start" then
        
        g_DestPoint.x = o.x
        g_DestPoint.y = o.y
        
        g_Camera.x = g_DestPoint.x - gconst.CANVAS_WIDTH * 0.5
        g_Camera.y = g_DestPoint.y - gconst.CANVAS_HEIGHT * 0.5
        
    elseif o.type == "ball" then
        
        g_Balls:add(Ball.new(o.x, o.y))
        
    elseif o.type == "trigger_cloner" then
        
        g_Cloners:add(Cloner.new(o.x, o.y, o.width, o.height, o.properties["multiply"]))
        
    end
    
end

return RunnerGame
