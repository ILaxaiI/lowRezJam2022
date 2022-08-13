local beam = {timer = 0}
beam.__index = beam

local ship_atlas = require("graphics.sprites").ship_atlas
local iw,ih = ship_atlas:getDimensions()
local q = love.graphics.newQuad
local animation = require("util.animation")

local gamestate =require("gamestate")

local ent = require("entities.rays.ship_beam")
function beam.init(ai,entity)
    
    if ai.phase == "phase1" then
        ai.next = "laser"
    elseif ai.phase == "phase2" then
        ai.beamC = ((ai.beamC or 0) + 1)
        if ai.beamC > 2 then
            ai.next = "missile"
        else
            ai.next = "beam"
        end
    else
        ai.next = "beam"
    end
    ai.beam = ent:new(entity.x+20,entity.y+20,0)--(love.math.random()*math.pi-math.pi/2))
    ai.target.x = false
    if ai.phase == 3 then
        ai.beam.timescale = 1.8
    end
    gamestate.entities.entities:insert(ai.beam)
    ai.duration = love.math.random(2,2)
end

function beam.interupt(ai,entity)
    ai.beam:die()
end

function  beam.update(ai,entity,dt)

    if ai.beam.isDead then
        beam.transition(ai,"idle",entity)
    end
end

function beam.draw(ai,entity)    
    local len = math.max(0,entity.health/entity.maxHealth*56)
    entity.hq:setViewport(0,0,len,1,2,1)
    love.graphics.draw(entity.health_sprite,entity.hq,4,1)

end
return beam