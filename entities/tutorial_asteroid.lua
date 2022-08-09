local tutorial_asteroid = require("entities.asteroid"):extend()

local gamestate = require("gamestate")

function  tutorial_asteroid:update(dt)
    self.y = self.y + dt*self.vy
    self.x = self.x + dt*self.vx

    print(self.y)

    if self.y > 64 then
        self.isDead = true
        gamestate.progressFlags.tutorial_asteroid_dodged = true
    end
end


function tutorial_asteroid:takeDamage(dmg)
    self.health = self.health - dmg
    if self.health <= 0 then 
        gamestate.progressFlags.tutorial_asteroid_destroyed = true
        self:die(true) 
    
    end
end

return tutorial_asteroid