local game = {}

local scene = require("util.state")
local gamestate = require("gamestate")
local level = require("levels.level")
local animation = require("util.animation")
local background = require("ui.background")

local habitat = require("entities.habitat")


function  game.reset()
    gamestate.default()
    gamestate.player.entity = habitat:new()
end

function game.init(_,reset)
    if reset or not gamestate.player.entity then
        level.set(level.loaded[gamestate.currentLevel].name)
        game.reset()
    end
end


function  game.exit()
    if gamestate.guns[gamestate.selectedWeapon] and
    gamestate.guns[gamestate.selectedWeapon].weapon then
        gamestate.guns[gamestate.selectedWeapon].weapon:mouseReleased()
    end
end

function game.selectGun(new)
    if new == gamestate.selectedWeapon then return end
    local old = gamestate.selectedWeapon
    local currentWeapon = gamestate.guns[old]
    if  gamestate.guns[new] and gamestate.guns[new]:select() then
        gamestate.selectedWeapon = new
        if currentWeapon then
            currentWeapon:deselect()
        end
    end
end

function  game.wheelmoved(dx,dy)
    game.selectGun((gamestate.selectedWeapon+dy)%4)
end



local ndisp = require("player.money_display")
function  game.update(dt)
       
 
    ndisp:update(dt)
    level.update(dt)
    animation.updateDetached(dt)
    
    background.update(dt)
    if love.mouse.isDown(1) and
        gamestate.guns[gamestate.selectedWeapon] ~= nil and
        gamestate.guns[gamestate.selectedWeapon].weapon then
            gamestate.guns[gamestate.selectedWeapon].weapon:mouseDown()
    end

    if love.keyboard.isScancodeDown("a","left") then
        gamestate.player.entity.x = math.max(-12,gamestate.player.entity.x - gamestate.stats.player_speed*dt)
    end
    if love.keyboard.isScancodeDown("d","right") then
        gamestate.player.entity.x = math.min(64-30+12,gamestate.player.entity.x + gamestate.stats.player_speed*dt)
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
local bh = require("entities.enemies").black_hole
local text = require("ui.elements.text")
local bhrender = false

local tutorial = {
    movement_prompt = text:new("[A/Left arrow]\n[d/Right arrow]\nto move",2,20),
    shop_prompt = text:new("[B] to open shop ",2,20),
    shoot_prompt = text:new("Mouse to aim\nClick to shoot\n[1-3]/Mouse wheel\nto swap",2,20),

    buy_some_damn_stuff_prompt = text:new("[B] to Buy\nupgrades",2,20)
}
game.shop_reminder_used = false

function  game.draw()
    viewport.beginRender()
    background.draw()

    gamestate.player.entity:draw(dt)

    if gamestate.player.money >= 3000 and not game.shop_reminder_used then
        tutorial.buy_some_damn_stuff_prompt:draw()
    end

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
        elseif gamestate.currentSection == 3 and not gamestate.progressFlags.tutorial_asteroid_destroyed then
            tutorial.shoot_prompt:draw()
        end

    end
    love.graphics.setCanvas()

    viewport.draw()
    

    -- DEBUG STUFF
   -- love.graphics.print(level.current.name.." "..gamestate.currentSection,0,15,0,4)
end

function game.mousereleased(x,y,b)
    if b == 1 and
        gamestate.guns[gamestate.selectedWeapon] ~= nil and
        gamestate.guns[gamestate.selectedWeapon].weapon then
            gamestate.guns[gamestate.selectedWeapon].weapon:mouseReleased()
    end
end


function  game.keypressed(key,code)
    if gamestate.progressFlags.tutorial_asteroid_dodged and
    code == "b" then
        if gamestate.player.money >= 3000 and not game.shop_reminder_used then game.shop_reminder_used = true end
        scene.set("shop")
    end
    if code == "1" or code == "kp1" then game.selectGun(0) end
    if code == "2" or code == "kp1" then game.selectGun(1) end
    if code == "3" or code == "kp1" then game.selectGun(2) end
    if code == "escape" then scene.set("options","game") end
end

return game