local game = {}
local star = love.graphics.newImage("graphics/star.png")
local stars = love.graphics.newParticleSystem(star,1000)

stars:setDirection(0,1)
stars:setEmissionRate(4)
stars:setEmissionArea("uniform",64,1,0,false)

stars:setParticleLifetime(30)
stars:setDirection(math.pi/2)
stars:setSpeed(8,8)
stars:setSizes(1)
stars:start()

local music = require("audio.music")


for i = 1,20 do
    stars:update(3)
end

local gamestate = require("gamestate")
local gunSpawns = {3,14,44,55}

local habitat = require("entities.habitat").new()


    local gun = require("entities.gunbase")
    local gunBases = {}
    gamestate.player.guns = {}

for i,v in ipairs(gunSpawns) do
    local g =  gun.new(gunSpawns[i])
    gamestate.entities.habitat:insert(g)
    gunBases[i-1] = g
end


gamestate.entities.habitat:insert( habitat)
gunBases[0]:attach(require("player.guns.cannon2shot").new())
gunBases[1]:attach(require("player.guns.cannon").new())
local selectedWeapon = 0
gunBases[0]:select()


local healthbar = require("ui.healthbar")


function  game.wheelmoved(dx,dy)
    local old = selectedWeapon
    local currentWeapon = gunBases[old].weapon

    if gunBases[(old+dy)%4]:select() then
        selectedWeapon = (old+dy)%4

        currentWeapon.isSelected = false
        currentWeapon:switchOff()
    end
end



local asteroid = require("entities.asteroid")
local radiation = require("entities.radiation")
local flare = require("entities.solarflare")

local level = require("levels.level")


local animation = require("util.animation")

function  game.update(dt)
    level.update(dt)
    animation.updateDetached(dt)
    
    if love.mouse.isDown(1) and
        gunBases[selectedWeapon] ~= nil and
        gunBases[selectedWeapon].weapon then
            gunBases[selectedWeapon].weapon:mouseDown()
    end

    if love.keyboard.isDown("a","left") then
        habitat.x = math.max(-12,habitat.x - 10*dt)
    end
    if love.keyboard.isDown("d","right") then
        habitat.x = math.min(64-30+12,habitat.x + 10*dt)
    end
    stars:update(dt)
    
    for i = #gamestate.entities.bullets,1,-1 do
        local v = gamestate.entities.bullets[i]
        if v.update and not v.isDead  then v:update(dt) end
    end
    for i = #gamestate.entities.entities,1,-1 do
        local v = gamestate.entities.entities[i]
        if v.update and not v.isDead  then v:update(dt) end
    end
    for i = #gamestate.entities.habitat,1,-1 do
        local v = gamestate.entities.habitat[i]
        if v.update and not v.isDead  then v:update(dt) end
    end



    for _,etype in pairs(gamestate.entities) do
        for i = #etype,1,-1 do
            if etype[i].isDead then
                etype:remove(etype[i])
            end
        end
    end


end



local viewport = require("ui.viewport")

local vec2 = require("util.vec2")
local bh = require("entities.enemies").black_hole

function  game.draw()
    viewport.beginRender()
    love.graphics.draw(stars,0,-2)
    
    
    
    love.graphics.setColor(1,1,1)
    for i,v in ipairs(gamestate.entities.habitat) do
        if v.draw and not v.isDead then v:draw() end
    end
    for i,v in ipairs(gamestate.entities.entities) do
        if v.draw and not v.isDead then v:draw() end
    end
    for i,v in ipairs(gamestate.entities.bullets) do
        if v.draw and not v.isDead then v:draw() end
    end

    animation.drawDetached()
 
    viewport.endRender()
    bh:render()
    viewport.draw()
    

    -- DEBUG STUFF
    love.graphics.print(love.timer.getFPS())
    love.graphics.print(level.current.name,0,15)
end

function game.mousereleased(x,y,b)
    if b == 1 and
        gunBases[selectedWeapon] ~= nil and
        gunBases[selectedWeapon].weapon then
            gunBases[selectedWeapon].weapon:mouseReleased()
    end
end

local upgrades = require("player.upgrades.auguments")
function  game.keypressed(key)
    if key == "w" then upgrades.purchase("gun_firerate") end
    if key == "e" then upgrades.purchase("gun_damage") end
    if key == "space" then 
        gamestate.player.health = gamestate.player.health - 1
    end
end

return game