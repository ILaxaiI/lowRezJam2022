local game = {}


local music = require("audio.music")



local gamestate = require("gamestate")
local gunSpawns = {3,14,44,55}
local habitat
--local habitat = require("entities.habitat").new()

function game.init(_,hab)
    if hab then
        if habitat then
            gamestate.entities.habitat:remove(habitat)
        end
        habitat = hab
        gamestate.entities.habitat:insert(hab)
        gamestate.player.entity = hab
    end
end




    local gun = require("entities.gunbase")
    local gunBases = {}
    gamestate.player.guns = {}

    local g =  gun.new(gunSpawns[1])
    gamestate.entities.habitat:insert(g)
    gunBases[0] = g



gunBases[0]:attach(require("entities.guns.cannon").new())
gunBases[0]:select()
local selectedWeapon = 0


local healthbar = require("ui.healthbar")

local function  selectGun(new)
    local old = selectedWeapon
    local currentWeapon = gunBases[old].weapon
    if  gunBases[new] and gunBases[new]:select() then
        selectedWeapon = new
        currentWeapon.isSelected = false
        currentWeapon:switchOff()
    end
end

function  game.wheelmoved(dx,dy)
    selectGun((selectedWeapon+dy)%4)
end






local level = require("levels.level")


local animation = require("util.animation")

local background = require("ui.background")
function  game.update(dt)
    level.update(dt)
    animation.updateDetached(dt)
    
    background.update(dt)
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

local text = require("ui.text")
local bhrender = false
function  game.draw()
    viewport.beginRender()
    background.draw()
    
    
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
    if bhrender then
        love.graphics.setCanvas(viewport.canvas)
        for i,v in ipairs(gamestate.entities.entities) do
            v:drawHitbox()
        end
        love.graphics.setCanvas()
    end


    
    love.graphics.setCanvas(viewport.canvas)
    text.printNumber(gamestate.player.money,62,2,4)
    love.graphics.setCanvas()

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
local scene = require("util.state")
function  game.keypressed(key)
    if key == "b" then scene.set("shop") end
    if key == "space" then 
        gamestate.player.health = gamestate.player.health - 1
    end





    local old = selectedWeapon
    local currentWeapon = gunBases[old].weapon
    if key == "1" then selectGun(0) end
    if key == "2" then selectGun(1) end
    if key == "3" then selectGun(2) end
    if key == "4" then selectGun(3) end


end

return game