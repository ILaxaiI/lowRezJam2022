local damage1 = {timer = 0}
damage1.__index = damage1

function damage1.init(ai,entity)
    ai.timer = 0
    ai.explosion = 0
    ai.nextExplosion = love.math.random()*.3+.2

    ai.next = "beam"
    ai.duration = 6
    
    ai.damageAble = false
    ai.spawnedDebris = false
    entity.speed = 30
    entity.health = entity.maxHealth
end
local explosions = {
    require("graphics.animations.smallexplosion"),
    require("graphics.animations.blue_explosion"),
    require("graphics.animations.explosion")
}

local debris = require("entities.ships.debris")
local gamestate = require("gamestate")
function  damage1.update(ai,entity,dt)
    ai.timer = ai.timer + dt
    ai.explosion = ai.explosion + dt
    if ai.explosion >= ai.nextExplosion then
        explosions[love.math.random(1,3)]:create():startDetached(entity.x+love.math.random(7,32),entity.y+love.math.random(2,18))
        ai.explosion = 0
        ai.nextExplosion= love.math.random()*.3+.2
    end

    if ai.timer >= 2 and not ai.spawnedDebris then
        local d = debris:new(entity.x+7,entity.y+2,3)
        d.vx = -love.math.random()*3 -2
        d.vy = 10 + love.math.random()*5
        d.av = -love.math.random() - .5
        gamestate.entities.entities:insert(d)
        
        ai.spawnedDebris= true

        local d = debris:new(entity.x+28,entity.y+2,4)
        d.vx = love.math.random()*3 +2
        d.vy = 10 + love.math.random()*5
        d.av = love.math.random() + .5
        gamestate.entities.entities:insert(d)
        ai.phase = "phase3"
    end

    if ai.timer >= ai.duration  then


        damage1.transition(ai,"idle",entity)
    end
end

function damage1.draw(ai,entity)
    local len = math.lerpc(0,entity.health/entity.maxHealth,ai.timer/ ai.duration)*56
    entity.hq:setViewport(0,0,len,1,2,1)
    love.graphics.draw(entity.health_sprite,entity.hq,4,1)
end
return damage1