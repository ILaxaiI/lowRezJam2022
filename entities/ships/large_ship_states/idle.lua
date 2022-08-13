local idle = {timer = 0}
idle.__index = idle

function idle.init(ai,entity)
    ai.timer = 0
    ai.damageAble = true
    if ai.phase == "phase1" then
        ai.duration = love.math.random(1.5,2)
    elseif ai.phase == "phase2" then
        ai.duration = love.math.random(.7,1.2)
    else
        ai.duration = love.math.random(.5,.7)
    end
end
local gamestate = require("gamestate")


function  idle.update(ai,entity,dt)
    ai.timer = ai.timer + dt
    
    
    if gamestate.player.entity then
        ai.target.x = gamestate.player.entity.x + gamestate.player.entity.w/2 -entity.w/2
    end

    if ai.timer >= ai.duration then
        ai.timer = 0
        idle.transition(ai,ai.next,entity)
    end
end

function idle.draw(ai,entity)
    local len = math.max(0,entity.health/entity.maxHealth*56)
    entity.hq:setViewport(0,0,len,1,2,1)
    love.graphics.draw(entity.health_sprite,entity.hq,4,1)
end
return idle