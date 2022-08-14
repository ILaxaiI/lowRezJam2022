local settings = require("settings")
local sfx = {pools = {}}

function sfx.setVolume(vol)
    for i,v in pairs(sfx.pools) do
        for i2,source in ipairs(v) do
            source:setVolume(vol)
        end
    end
    sfx.shieldEffect:setVolume(vol*.5)
end

function sfx.load(filepath,name,count)
    local pool = {n = 1}
    for i = 1,count or 5 do
        pool[i] = love.audio.newSource(filepath,"static")
    end
    sfx.pools[name] = pool
end

function sfx.play(name,pitch,vol)
    local n = sfx.pools[name].n
    local source = sfx.pools[name][n]
    source:setPitch(pitch or 1)
    source:stop()
    source:setVolume(settings.sfxVolume*(vol or 1))
    source:play()
    sfx.pools[name].n = (n)%#sfx.pools[name] + 1
end




sfx.load("audio/sfx/explosion.wav","explosion1",5)
sfx.load("audio/sfx/8bit_bomb_explosion.wav","explosion2",5)


sfx.load("audio/sfx/laserSmall_000.ogg","laser0",5)
sfx.load("audio/sfx/laserSmall_001.ogg","laser1",5)
sfx.load("audio/sfx/laserSmall_002.ogg","laser2",5)
sfx.load("audio/sfx/laserSmall_003.ogg","laser3",5)
sfx.load("audio/sfx/laserSmall_004.ogg","laser4",5)

sfx.shieldEffect = love.audio.newSource("audio/sfx/spaceEngine_002.ogg","static")
--sfx.shieldEffect:setLooping(true)



sfx.load("audio/sfx/laserLarge_003.ogg","largeLaser3",5)

sfx.setVolume(settings.sfxVolume)
return sfx