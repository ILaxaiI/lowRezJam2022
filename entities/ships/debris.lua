local debris = require("entities.entity"):extend()

debris.sprite = require("graphics.sprites").ship_atlas
local quads = {
    
    love.graphics.newQuad(55,59,6,12,93,71), --left wing
    love.graphics.newQuad(64,59,6,12,93,71), -- right wing
    love.graphics.newQuad(72,60,11,11,93,71),
    love.graphics.newQuad(85,60,8,11,93,71),
}

function  debris:new(x,y,t)
    local d = {
        x = x,
        y = y,
        q = quads[t],
        r = 0,
        av = 0,
        vx = 0,
        vy = 0,
    }


    _,_,d.w,d.h = d.q:getViewport()
return setmetatable(d,debris)
end


function  debris:update(dt)
    self.x = self.x + self.vx*dt
    self.y = self.y + self.vy*dt
    self.r = self.r +self.av*dt
end

function  debris:overlap()
    return false
end

function  debris:draw(dt)
    love.graphics.draw(debris.sprite,self.q,self.x+self.w/2,self.y+self.h/2,self.r,1,1,self.w/2,self.w/2)
end

return debris