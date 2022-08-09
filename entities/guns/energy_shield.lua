local shield  = require("entities.guns.gun"):extend()
shield.head= require("graphics.sprites").energy_shield_head

shield.barrel = require("graphics.sprites").energy_shield_barrel
shield.barrelWidth = shield.barrel:getWidth()
shield.barrelHeight = shield.barrel:getHeight()
shield.headHeight = shield.head:getHeight()
shield.cd = 4



local shieldEntity = require("entities.shield")
local gamestate = require("gamestate")

local viewport = require("ui.viewport")

local activeShield
shield.sfx = love.audio.newSource("audio/sfx/spaceEngine_002.ogg","static")
shield.sfx:setVolume(.1)
shield.sfx:setLooping(true)
function  shield:mouseDown()
    if activeShield then
        activeShield.hybernate = false
        if activeShield.isDead then 
            activeShield = nil 
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

    if not activeShield then
        activeShield = shieldEntity:new(mx,my,self.barrelAngle)
        activeShield.parent = self
        gamestate.entities.bullets:insert(activeShield)
    elseif activeShield then
        
        activeShield.x = mx
        activeShield.y = my
        activeShield.angle =self.barrelAngle

    end
end
end


function  shield:mouseReleased()
    if activeShield and not activeShield.isDead then
        activeShield.hybernate = true
        shield.sfx:stop()
    end
end


function  shield:switchOff()
    self:mouseReleased()
end
return shield