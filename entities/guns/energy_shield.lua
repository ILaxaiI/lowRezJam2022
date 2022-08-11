local shield  = require("entities.guns.gun"):extend()
shield.head= require("graphics.sprites").energy_shield_head

shield.barrel = require("graphics.sprites").energy_shield_barrel
shield.barrelWidth = shield.barrel:getWidth()
shield.barrelHeight = shield.barrel:getHeight()
shield.headHeight = shield.head:getHeight()
shield.cd = 4



local shieldEntity = require("entities.bullets.shield")
local gamestate = require("gamestate")

local viewport = require("ui.viewport")

shield.sfx = love.audio.newSource("audio/sfx/spaceEngine_002.ogg","static")
shield.sfx:setVolume(.1)
shield.sfx:setLooping(true)
function  shield:mouseDown()
    if self.activeShield then
        self.activeShield.hybernate = false

        if self.activeShield.isDead then
            self.activeShield = nil
            shield.sfx:stop()
        else
            shield.sfx:play()
        end
    end
    
    if self.cooldown <= 0 then
    local mx,my = love.mouse.getPosition()
    local scale = viewport.getScale()
    local offsetx,offsety = viewport.getOffset()

    mx = mx/scale - offsetx
    my = my/scale - offsety

    if not self.activeShield then
        self.activeShield = shieldEntity:new(mx,my,self.barrelAngle)
        self.activeShield.parent = self
        gamestate.entities.bullets:insert(self.activeShield)
    elseif self.activeShield then
        self.activeShield.x = mx
        self.activeShield.y = my
        self.activeShield.angle =self.barrelAngle

    end
end
end


function  shield:mouseReleased()
    if self.activeShield and not self.activeShield.isDead then
        self.activeShield.hybernate = true
        
        shield.sfx:stop()
    end
end


function  shield:switchOff()
    self:mouseReleased()
end
return shield