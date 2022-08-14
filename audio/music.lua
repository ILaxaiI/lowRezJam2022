local music = {}
music.filler = love.audio.newSource("audio/music/lowrezjam_lvl_1_-_2_filler_loop_16_bit.wav","static")

music.intro = love.audio.newSource("audio/music/lowrezjam-soundtrack-intro-_DOES-NOT-LOOP_.mp3","static")
music.transition = love.audio.newSource("audio/music/lowrezjam-soundtrack-Loop-1-first-pass.mp3","static")

music.loop1 = love.audio.newSource("audio/music/lowrezjam-soundtrack-Loop-1.mp3","static")

music.loop2 = love.audio.newSource("audio/music/lowrezjam-soundtrack-Loop-2.mp3","static")

music.loop3_intro = love.audio.newSource("audio/music/Loop-3-intro.mp3","static")
music.loop3_1 = love.audio.newSource("audio/music/Loop-3-part-1.mp3","static")
music.loop3_2 = love.audio.newSource("audio/music/Loop-3-part-2.mp3","static")

music.loop4_intro = love.audio.newSource("audio/music/Loop-4-part-1-intro.mp3","static")
music.loop4 = love.audio.newSource("audio/music/Loop-4-part-2-_LOOP_.mp3","static")

music.boss1 = love.audio.newSource("audio/music/lowrezjam-Boss-Intro.mp3","static")
music.boss2 = love.audio.newSource("audio/music/lowrezjam-Boss-1.mp3","static")
music.boss3 = love.audio.newSource("audio/music/lowrezjam-Boss-2.mp3","static")


function  music.setVolume(vol)
    for i,v in pairs(music) do
        if i ~= "setVolume" then
        v:setVolume(vol)
        end
    end
end

local settings = require("settings")
music.setVolume(settings.musicVolume)
return music