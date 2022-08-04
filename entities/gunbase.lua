local gunbase = require("entities.entity"):extend()
gunbase.__index =gunbase
gunbase.type = "gunbase"
gunbase.base = love.graphics.newImage("graphics/gun_base.png")



function gunbase.new(x)
    return setmetatable({
        x = x,
        y = 44,
        animT = love.math.random(0,10),
    },gunbase)
end

function  gunbase:attach(weapon)
    self.weapon = weapon
    weapon.parent = self
end

function  gunbase:update(dt)
   -- self.animT = self.animT + dt*5
    if self.weapon then
        self.weapon:update(dt)
    end

end


function  gunbase:select()
    if self.weapon then
        self.weapon.isSelected = true
        return self.weapon
    end    
end

function  gunbase:draw()
    love.graphics.draw(self.base,self.x,self.y)
    if self.weapon then
        love.graphics.push()
        love.graphics.translate(self.x,self.y)
        self.weapon:draw()
        love.graphics.pop()
    end
end

return gunbase