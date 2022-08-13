local habitat = require("entities.entity"):extend()
--habitat.__index = habitat
habitat.sprite = require("graphics.sprites").habitat_wide
habitat.type = "habitat"
habitat.w = 24--26
habitat.h = 4--7
habitat.aabbyo = 7
habitat.aabbxo = 3

habitat.__tostring = function() return "habitat" end

function habitat:new()
    return setmetatable({
        x =17,
        y = 47,
        animT = 0,
        payoutTimer = 0,
        etimer = 0,
    },self)
end

local overlap = require("util.overlap")
local gamestate = require("gamestate")
local ex =  { require("graphics.animations.explosion"), require("graphics.animations.smallexplosion")}
function  habitat:animate(dt)
    self.animT = self.animT + dt*5
end
local animations = require("util.animation")




function  habitat:update(dt)

    self:animate(dt)

    if not self.isDead then
        self.payoutTimer = self.payoutTimer + dt
        if self.payoutTimer > 5 then
            gamestate.player.money = gamestate.player.money + gamestate.player.passive_income
            self.payoutTimer = self.payoutTimer - 5
        end
        
        gamestate.player.health = math.min(gamestate.player.maxHealth,gamestate.player.health + dt*gamestate.stats.player_regen)

        for i,ent in ipairs(gamestate.entities.entities) do
            if (ent.collidewithplayer) and not ent.isDead and
                ent.overlap(self,ent) then
                    ent:impactPlayer(dt)
            end
        end
        if gamestate.player.health <= 0 then self:die() end
    else
        self.etimer = self.etimer - dt
        if self.etimer <= 0 then
        animations.startDetached(ex[love.math.random(1,2)]:create(),self.x + love.math.random(0,self.w),self.y+love.math.random(self.h))
        self.etimer = love.math.random()*.2+.2

        end
    end
end
local healthbar = require("ui.healthbar")

function  habitat:draw()

    local y = self.y+.5*(math.sin(self.animT)+1)
    love.graphics.draw(self.sprite,self.x,y)
    healthbar:draw(self.x+3,y+6)

end

return habitat