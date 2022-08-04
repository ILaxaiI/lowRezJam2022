local radiation = require("entities.entity"):extend()
radiation.sprite = require("graphics.sprites").radiation
radiation.type = "radiation"
radiation.w = 10
radiation.h = 10
radiation.damage = 1
radiation.collidewithplayer = true

local rnd = love.math.random
function radiation.new(speed)
    local regions = radiation.spawnRegions
    local spawnRegion = regions[rnd(1,#regions)]
    local x,y = rnd(spawnRegion[1],spawnRegion[3]),rnd(spawnRegion[2],spawnRegion[4])


    return setmetatable({
        x = x,
        y = y,
        vx = 0,
        vy = speed,
        health = 5,
    },radiation)
end


function  radiation:update(dt)
    self.y = self.y + dt*self.vy
    self.x = self.x + dt*self.vx
    
    if self.y > 64 then self.isDead = true end
end

function  radiation:draw()
    love.graphics.draw(self.sprite,self.x,self.y)
    
end


return radiation