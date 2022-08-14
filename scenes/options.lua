local options = {}

local viewport = require("ui.viewport")
local background = require("ui.background")

local scene = require("util.state")
local button = require("ui.elements.button")
local settings = require("settings")
local sfx = require("audio.sfx.sfx")
local music = require("audio.music")
local sliders = {
    {x = 32,y = 24,w = 28,p = settings.musicVolume,
    func = function (self)
        settings.musicVolume = self.p
        music.setVolume(settings.musicVolume)
    end
},
    {x = 32,y = 32,w = 28,p = settings.sfxVolume,
    func = function (self)
        settings.sfxVolume = self.p
        sfx.setVolume(settings.sfxVolume)
    end
},
}
options.pre = "mainemnu"
function options.init(_,pres)
    options.pre = pres
end

local close = button:new(
    require("graphics.sprites").button_atlas,
    {love.graphics.newQuad(22,11,10,10,64,64),love.graphics.newQuad(33,11,10,10,64,64)},
    2,2,10,10,function () scene.set(options.pre) end)


local sliderHeld = false
local level = require("levels.level")
function  options.update(dt)
    background.update(dt)
    level.updateMusic(dt)

    x,y = viewport.translate(love.mouse.getPosition())
    if sliderHeld  then
        sliderHeld.p = math.min(1,math.max(0,((x - sliderHeld.x)/sliderHeld.w)))
        sliderHeld.func(sliderHeld)
    end
end

function  options.draw()

    viewport.beginRender()
    background.draw()
    close:draw()
    love.graphics.print("Music",2,22)
    love.graphics.print("SFX",2,30)
    for i,v in ipairs(sliders) do
        love.graphics.line(v.x,v.y,v.x+v.w,v.y)
        love.graphics.circle("fill",v.x + v.w*v.p,v.y,2)
    end

    viewport.endRender()
    viewport.draw()

end


function  options.keypressed(key)
    if key == "escape" then
        scene.set(options.pre  or "mainmenu")
    end
end


function  options.mousepressed(x,y,b)
    if b == 1 then
        x,y = viewport.translate(x,y)
        for i,v in ipairs(sliders) do
            if math.abs(v.x+v.w*v.p - x) <= 2 and math.abs(v.y-y) <= 2 then
                sliderHeld = v
            end
        end
        close:clicked(x,y)
    end
end

function  options.mousereleased(x,y,b)
    if b == 1 then
        if sliderHeld then
            sliderHeld.func(sliderHeld)
            
            if sliderHeld == sliders[2] then sfx.play("explosion1") end
            settings:save()
            sliderHeld = false
        end
        x,y = viewport.translate(x,y)
        close:released(x,y)
    end
end
return options