local spawning = {timer = 0}
spawning.__index = spawning
local spawn_speed = 9

function  spawning.update(ai,entity,dt)
    ai.timer = ai.timer + dt
    entity.y = math.lerpc(-22,0,ai.timer/spawn_speed)
    if ai.timer >= spawn_speed then
        ai.timer = 0
        ai.damageAble = true
        ai.next = "laser"
        spawning.transition(ai,"idle")
    end
end

function spawning.draw(ai,entity)
    entity.hq:setViewport(0,0,math.lerpc(0,entity.health/entity.maxHealth,ai.timer/spawn_speed)*56,1,2,1)
    love.graphics.draw(entity.health_sprite,entity.hq,4,1)
end
return spawning