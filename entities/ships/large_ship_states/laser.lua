local laser = {timer = 0}
laser.__index = laser

function laser.init(ai)
    ai.timer = 0
    ai.bulletTimer = 0
    ai.barrel = 0
    ai.next = "missile"
    ai.duration = love.math.random(2,3)
end
local gamestate =require("gamestate")
local laser_bolt = require("entities.bullets.green_laser")
local barrels = {[0] = {x=2,r =math.rad(90 - 15)},{x=38,r =math.rad(90+ 15)}}
local sfx = { laser = love.audio.newSource("audio/sfx/laserLarge_003.ogg","static"),}


local sfx = require("audio.sfx.sfx")
function  laser.update(ai,entity,dt)
    ai.timer = ai.timer + dt
    ai.bulletTimer = ai.bulletTimer + dt
    if ai.bulletTimer >= 1/entity.laserFirerate then
        ai.barrel = (ai.barrel + 1)%2
        sfx.play("largeLaser3")
        gamestate.entities.entities:insert(laser_bolt:new(entity.x + barrels[ai.barrel].x,13,barrels[ai.barrel].r))
        ai.bulletTimer = 0
    end

    if ai.timer >= ai.duration then
        if love.math.random() > .7 then
            ai.next = "laser"
        else
            ai.next = "missile"
        end
        ai.timer = 0
        laser.transition(ai,"idle")
    end
end

function laser.draw(ai,entity)    
    local len = math.max(0,entity.health/entity.maxHealth*56)
    entity.hq:setViewport(0,0,len,1,2,1)
    love.graphics.draw(entity.health_sprite,entity.hq,4,1)
end
return laser