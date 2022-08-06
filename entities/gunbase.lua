local gunbase = require("entities.entity"):extend()
gunbase.__index =gunbase
gunbase.type = "gunbase"
gunbase.base = love.graphics.newImage("graphics/gun_base.png")

gunbase.targetY = 44


function gunbase.new(x)
    return setmetatable({
        x = x,
        y = 67,
        spawning = true,
        animT = love.math.random(0,10),
    },gunbase)
end

function  gunbase:attach(weapon)
    self.weapon = weapon
    weapon.parent = self
end

function  gunbase:spawned(dt)
    if self.spawning and self.y > self.targetY then
        self.y = self.y - 30*dt
        if math.abs(self.targetY-self.y) < .5 then
            self.y = self.targetY
            self.spawning = false
        end    
    end

end

function  gunbase:update(dt)
    if self.spawning then self:spawned(dt) end
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