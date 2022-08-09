local game = {}

local scene = require("util.state")
local gamestate = require("gamestate")
local level = require("levels.level")
local animation = require("util.animation")
local background = require("ui.background")

local selectedWeapon = 0



function  game.reset()
    gamestate.default()
    gamestate.player.entity = require("entities.habitat"):new()
 
end
local music = require("audio.music")
local musicVolume = 0
local musicPrevol

function game.init(_,reset) 
    musicVolume = 0
    musicPrevol = music.source:getVolume()
    if reset or not gamestate.player.entity then
        print("reset")
        game.reset()
    end
end




local function  selectGun(new)
    local old = selectedWeapon
    local currentWeapon = gamestate.guns[old] and gamestate.guns[old].weapon
    if  gamestate.guns[new] and gamestate.guns[new]:select() then
        selectedWeapon = new
        if currentWeapon then
            currentWeapon.isSelected = false
            currentWeapon:switchOff()
        end
    end
end

function  game.wheelmoved(dx,dy)
    selectGun((selectedWeapon+dy)%4)
end




function  game.update(dt)
       
    musicVolume = musicVolume+dt
    local vol = math.lerpc(musicPrevol,music.volume,musicVolume)

    music.source:setVolume(vol)

    level.update(dt)
    animation.updateDetached(dt)
    
    background.update(dt)
    if love.mouse.isDown(1) and
        gamestate.guns[selectedWeapon] ~= nil and
        gamestate.guns[selectedWeapon].weapon then
            gamestate.guns[selectedWeapon].weapon:mouseDown()
    end

    if love.keyboard.isDown("a","left") then
        gamestate.player.entity.x = math.max(-12,gamestate.player.entity.x - 15*dt)
    end
    if love.keyboard.isDown("d","right") then
        gamestate.player.entity.x = math.min(64-30+12,gamestate.player.entity.x + 15*dt)
    end
    
    for i = #gamestate.entities.bullets,1,-1 do
        local v = gamestate.entities.bullets[i]
        if v.update and not v.isDead  then v:update(dt) end
    end
    for i = #gamestate.entities.entities,1,-1 do
        local v = gamestate.entities.entities[i]
        if v.update and not v.isDead  then v:update(dt) end
    end

    gamestate.player.entity:update(dt)

    for i = #gamestate.guns,0,-1 do
  
        local v = gamestate.guns[i]
        if v and v.update and not v.isDead  then v:update(dt) end
      
    end

    if gamestate.player.health <= 0 then
        scene.set("gameOver")
        require("entities.enemies").black_hole.clear()
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
local text = require("ui.elements.text")
local bhrender = false

local ndisp = require("ui.elements.money_display"):new(gamestate.player.money,62,2)

local tutorial = {
    movement_prompt = text:new("[A/Left arrow]\n[d/Right arrow]\nto move",2,20),
    shop_prompt = text:new("[B] to open shop ",2,20),

}

function  game.draw()
    viewport.beginRender()
    background.draw()

    gamestate.player.entity:draw(dt)
    for i = #gamestate.guns,0,-1 do
        local v = gamestate.guns[i]
        if v and v.draw and not v.isDead  then v:draw() end
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
    ndisp.n = tostring(gamestate.player.money)
    ndisp:draw()
    if level.current.name == "tutorial" then
        if gamestate.currentSection == 1 then
            tutorial.movement_prompt:draw()
        elseif gamestate.currentSection == 2 then
            tutorial.shop_prompt:draw()
        end

    end
    love.graphics.setCanvas()

    viewport.draw()
    

    -- DEBUG STUFF
    love.graphics.print(level.current.name.." "..gamestate.currentSection,0,15,0,4)
end

function game.mousereleased(x,y,b)
    if b == 1 and
        gamestate.guns[selectedWeapon] ~= nil and
        gamestate.guns[selectedWeapon].weapon then
            gamestate.guns[selectedWeapon].weapon:mouseReleased()
    end
end


function  game.keypressed(key)
    if gamestate.progressFlags.tutorial_asteroid_dodged and
    key == "b" then scene.set("shop") end
    if key == "1" then selectGun(0) end
    if key == "2" then selectGun(1) end
    if key == "3" then selectGun(2) end
    if key == "4" then selectGun(3) end
end

return game