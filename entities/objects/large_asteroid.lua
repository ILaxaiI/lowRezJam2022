local large_asteroid = require("entities.entity"):extend()
--large_asteroid.sprite = require("graphics.sprites").asteroid

large_asteroid.type = "asteroid"
large_asteroid.damage = .05

large_asteroid.collidewithplayer = true
local ffi = require("ffi")


local sizes ={16,24}

large_asteroid.sizes = {
--[[    {
        grid = love.filesystem.read("data","entities/large_asteroid_grids/asteroid_size_8"),
        ctype = ffi.typeof("uint8_t(*)[$]",sizes[1])
    },]]

    {
        grid = love.filesystem.read("data","entities/objects/large_asteroid_grids/asteroid_size_16"),
        ctype = ffi.typeof("uint8_t(*)[$]",sizes[1])
    },
    {
        grid = love.filesystem.read("data","entities/objects/large_asteroid_grids/asteroid_size_24"),
        ctype = ffi.typeof("uint8_t(*)[$]",sizes[2])
    },
}
for i = 1,#sizes do
    large_asteroid.sizes[i].gridptr = ffi.cast(large_asteroid.sizes[i].ctype,large_asteroid.sizes[i].grid:getFFIPointer())
    local count = 0
    for x = 0,sizes[i]-1 do
        for y = 0,sizes[i]-1 do
            if large_asteroid.sizes[i].gridptr[x][y] ~= 0 then
                count = count + 1
            end
        end
    end
    large_asteroid.sizes[i].count = count
end

large_asteroid.spawnRegions = {{0,-27,60,-27}}

local function  getRandomWeigthedElement(ents)
    local val = love.math.random()
    for i,v in ipairs(ents) do
       val = val - v[2]
       if val <= 0 then return v end
    end
end
local sizeWeights = {{1,.85},{2,.15}}
function large_asteroid:new(max_size)
    local x,y = large_asteroid:getRandomSpawn()
    local size = max_size == 1 and 1 or getRandomWeigthedElement(sizeWeights)[1]
    local a = {
        x = x,
        y = y,
        grid = large_asteroid.sizes[size].grid:clone(),
        size = sizes[size],
        vx = 0,
        vy = 8,
        tileCount = large_asteroid.sizes[size].count
    }
    a.w = a.size
    a.h = a.size
    a.gridptr = ffi.cast(large_asteroid.sizes[size].ctype,a.grid:getFFIPointer())
    
    return setmetatable(a,self)
end


function  large_asteroid:update(dt)
    self.y = self.y + dt*self.vy
    self.x = self.x + dt*self.vx
    if self.tileCount <= 0 then self:die() end

    if self.y > 64 then self.isDead = true end
end

large_asteroid.sfx = {
    love.audio.newSource("audio/sfx/explosion.wav","static"),
    love.audio.newSource("audio/sfx/8bit_bomb_explosion.wav","static"),
}
large_asteroid.sfx[1]:setVolume(.1)
large_asteroid.sfx[2]:setVolume(.1)
local explosion = require("graphics.animations.explosion")
local animation = require("util.animation")

local gamestate = require("gamestate")


local overlap = require("util.overlap")

function large_asteroid.overlap(e1,e2)

    if not overlap.aabb(e1.x,e1.y,e1.w,e1.h,e2.x,e2.y,e2.size,e2.size) then return end
    
    local ex = math.floor(e1.x + (e1.aabbxo or 0) - e2.x)
    local ey = math.floor(e1.y + (e1.aabbyo or 0) - e2.y)

    for x = ex,ex+e1.w do
        if x>= 0 and x < e2.size then
        for y = ey,ey+e1.h do
            if y >= 0 and y < e2.size then
                if e2.gridptr[x][y] ~= 0 then return true end
            end
        end
        end
    end
end



function  large_asteroid:takeDamage(dmg,ent)
    if ent.explosionSize then
       
        local minx,maxx = math.floor(ent.explosionSize-1),math.floor(ent.explosionSize+1.5)
        local miny,maxy = math.floor(ent.explosionSize-1),math.floor(ent.explosionSize+1.5)
        local ex = math.floor(ent.x + (ent.aabbxo or 0) + ent.w/2 - self.x +.5)
        local ey = math.floor(ent.y + (ent.aabbyo or 0) + ent.h/2 - self.y +.5)
        local destroyed = 0
        for x = ex - minx, ex + maxx do
            if x>= 0 and x < self.size then
            for y = ey-miny,ey+maxy  do
                local dx = x - ex
                local dy = y - ey
                if y >= 0 and  y < self.size and self.gridptr[x][y] > 0 and math.sqrt(dx*dx+dy*dy) <= ent.explosionSize then
                    self.gridptr[x][y] = 0
                    destroyed = destroyed + 1
                    gamestate.player.money = gamestate.player.money + 10
                end
            end
        end
        end
        local ptc = self.tileCount
        self.tileCount = self.tileCount - destroyed
   else

        local ex = math.floor(ent.x + (ent.aabbxo or 0) - self.x)
        local ey = math.floor(ent.y + (ent.aabbyo or 0) - self.y)
  
        for x = ex , ex+ent.w do
            if x >= 0 and x < self.size then
            for y = ey,ey+ent.h  do
                if y >= 0 and  y < self.size and self.gridptr[x][y] ~= 0 then
                    self.gridptr[x][y] = 0
                    self.tileCount = self.tileCount - 1
                    gamestate.player.money = gamestate.player.money + 10
                end
            end
        end
        end

    end



    local sfx = love.math.random(1,2)
    large_asteroid.sfx[sfx]:stop()
    large_asteroid.sfx[sfx]:setPitch((love.math.random()-.2) + .8)
    large_asteroid.sfx[sfx]:play()
    
end
local gamestate = require("gamestate")
function  large_asteroid:impactPlayer(dt)

    local player = gamestate.player.entity
    self:takeDamage(0,player)
    gamestate.player.health = gamestate.player.health - 1
    
end

local colors = {
    {187/255,132/255,76/255},
    {164/255,113/255,60/255}
}

function  large_asteroid:draw()
    for x = 0,self.size-1 do
        for y = 0,self.size-1 do
            if colors[self.gridptr[x][y]] then
                love.graphics.setColor(colors[self.gridptr[x][y]])
                love.graphics.points(x+self.x,y+self.y)
            end
        end
    end love.graphics.setColor(1,1,1)
end


function  large_asteroid:die()
    local sfx = love.math.random(1,2)
    large_asteroid.sfx[sfx]:stop()
    large_asteroid.sfx[sfx]:setPitch((love.math.random()-.2) + .8)
    large_asteroid.sfx[sfx]:play()

    self.grid:release()
    self.gridptr = nil
    self.isDead = true
end
return large_asteroid