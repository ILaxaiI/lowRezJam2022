local habitat = require("entities.entity"):extend()
habitat.__index = habitat
habitat.sprite = require("graphics.sprites").habitat_wide
habitat.type = "habitat"
habitat.w = 24--26
habitat.h = 7--7
function habitat.new()
    return setmetatable({
        x =27,
        y = 47,
        animT = 0
    },habitat)
end

local overlap = require("util.overlap")
local gamestate = require("gamestate")

function  habitat:update(dt)
    self.animT = self.animT + dt*5


    for i,ent in ipairs(gamestate.entities.entities) do
        if (ent.collidewithplayer) and not ent.isDead and
            overlap.aabb(self.x+3,self.y+5,self.w,self.h,ent.x + (ent.aabbxo or 0),ent.y+ (ent.aabbxo or 0),ent.w,ent.h) then
                ent:impactPlayer(dt)
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