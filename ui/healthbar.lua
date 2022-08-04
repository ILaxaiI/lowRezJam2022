local healthbar = {}

local gamestate = require("gamestate")


healthbar.sprites = {
    bar = love.graphics.newImage("ui/Health_bar.png"),
    hp = love.graphics.newImage("ui/Hit_point.png"),
    stop = love.graphics.newImage("ui/Health_bar_stop.png")
}
healthbar.sprites.hp:setWrap("repeat")

local quad = love.graphics.newQuad(0,0,2,1,2,1)

function  healthbar:draw(x,y)
    x = x or 0
    y = y or 0
    
 --   love.graphics.draw(self.sprites.stop,x,y)
 --   love.graphics.draw(self.sprites.stop,gamestate.player.maxHealth*2+3 + x,y)
    
 --   for i = 0,gamestate.player.maxHealth do
  --      love.graphics.draw(self.sprites.bar,i*2+1+x,y)
 --   end
    local hpsize = math.max(gamestate.player.health/gamestate.player.maxHealth*20,0)
    quad:setViewport(0,0,hpsize,1,2,1)
    love.graphics.draw(self.sprites.hp,quad,x+2,y)

end


return healthbar