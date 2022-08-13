local missile = {timer = 0}
missile.__index = missile

function missile.init(ai)
    ai.timer = 0
    ai.bulletTimer = 0
    ai.barrel = 0
    ai.next = "beam"
    ai.duration = love.math.random(3,4)
end
local gamestate =require("gamestate")

local rocket = require("entities.bullets.rockets")
local barrels = {[0] = {x=10,r =math.rad(90 - 15)},{x=30,r =math.rad(90 - 15)}}



function  missile.update(ai,entity,dt)
    ai.timer = ai.timer + dt
    ai.bulletTimer = ai.bulletTimer + dt
    if ai.bulletTimer >= 1/entity.missileFirerate then
        ai.barrel = (ai.barrel + 1)%2
        local r = rocket:new(entity.x + barrels[ai.barrel].x,13,barrels[ai.barrel].r)
        r.acceleration = 40
        gamestate.entities.entities:insert(r)
        ai.bulletTimer = 0
    end

    if ai.timer >= ai.duration then
        ai.timer = 0
        if ai.phase == "phase2" then
            if love.math.random() > .5 then
                ai.next = "missile"
            else
                ai.next = "beam"
            end
        end


        missile.transition(ai,"idle")
    end
end

function missile.draw(ai,entity)
    local len = math.max(0,entity.health/entity.maxHealth*56)
    entity.hq:setViewport(0,0,len,1,2,1)
    love.graphics.draw(entity.health_sprite,entity.hq,4,1)
end
return missile