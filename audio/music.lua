local music = {}
music.intro = love.sound.newSoundData("audio/music/lowrezjam-soundtrack-intro-_DOES-NOT-LOOP_.mp3")
music.transition = love.sound.newSoundData("audio/music/lowrezjam-soundtrack-Loop-1-first-pass.mp3")
music.loop1 = love.sound.newSoundData("audio/music/lowrezjam-soundtrack-Loop-1.mp3")
music.loop2 = love.sound.newSoundData("audio/music/lowrezjam-soundtrack-Loop-2.mp3")
music.part2 = love.sound.newSoundData("audio/music/lowrezjam-soundtrack-second-part-full-demo.mp3")

music.source = love.audio.newQueueableSource( music.intro:getSampleRate(),

music.intro:getBitDepth(),
music.intro:getChannelCount(), buffercount ,20)
music.source:setVolume(.5)

return music