local gameOver = {}

local button = require("ui.elements.button")
local viewport = require("ui.viewport")
local q = love.graphics.newQuad
local buttonSprite = love.graphics.newImage("graphics/menus/play_button.png")
local iw,ih = buttonSprite:getWidth(),buttonSprite:getHeight()
local music = require("audio.music")

local state = require("util.state")
local animation = require("util.animation")
local gamestate = require("gamestate")
local level = require("levels.level")
local upgrades = require("player.upgrades")
local guns
local buttons = {
    button:new(
        buttonSprite,
        {love.graphics.newQuad(49,34,48,16,iw,ih),love.graphics.newQuad(49,51,48,16,iw,ih)},
        8,30,48,16,
        function ()
            
            music[level.currentMusic]:stop()
            level.musicIndex = 0
            level.currentMusic = false
            
            
            state.list["game"].reset()
            animation.clearDetached()
            state.set("mainmenu");
        end),
    button:new(
        buttonSprite,
        {love.graphics.newQuad(0,34,48,16,iw,ih),love.graphics.newQuad(0,51,48,16,iw,ih)},
        8,12,48,16,
        function ()
            local guns = gamestate.guns
            local lvl = gamestate.currentLevel.name
            
            music[level.currentMusic]:stop()
            level.musicIndex = 0
            level.currentMusic = false
            
            if gamestate.guns[1] and gamestate.guns[1].weapon and gamestate.guns[1].weapon.activeShield then
              
                gamestate.entities.bullets:remove(gamestate.guns[1].weapon.activeShield)
                gamestate.guns[1].weapon.activeShield = nil
                gamestate.guns[1].weapon.cooldown=0
            end
            local owned = gamestate.upgrades

            local pf = gamestate.progressFlags
            gamestate.default()
            gamestate.progressFlags = pf

            for n,v in pairs(owned) do
                
                for i = 1,v.level do
                    upgrades.purchase(n,true)
                end
            end

            gamestate.guns = guns
            gamestate.player.entity = require("entities.habitat"):new()
            level.set(lvl)

            state.set("game")



        end),
}

function  gameOver.mousepressed(x,y,b)
    if b == 1 then
        
    x,y = viewport.translate(x,y)
    for i,v in ipairs(buttons) do
        v:clicked(x,y)
    end
end
end


function  gameOver.mousereleased(x,y,b)
    if b == 1 then
        x,y = viewport.translate(x,y)
        for i,v in ipairs(buttons) do
            v:released(x,y)
        end
    end
end
local background = require("ui.background")



local gamestate = require("gamestate")
local animations = require("util.animation")
function  gameOver.update(dt)
    gamestate.player.entity:update(dt)
    animations.updateDetached(dt)
    background.update(dt)

end

function gameOver.draw()
    viewport.beginRender()
    background.draw()
    for i,v in ipairs(buttons) do
        v:draw()
    end
    
    gamestate.player.entity:draw()
    animations.drawDetached()
    viewport.endRender()
    viewport.draw()
end
return gameOver