local level = {}
level.loaded = {
    level1 = require("levels.level1"),
    level2 = require("levels.level2"),
    level3 = require("levels.level3"),
    level4 = require("levels.level4")
}
level.current = {next = "level4",duration = -1}


local music = require("audio.music")

local enemies = require("entities.enemies")
local gamestate = require("gamestate")

local soundQueue = music.source



local function  getRandomWeigthedElement(ents)
    local val = love.math.random()
    for i,v in ipairs(ents) do
       val = val - v[2]
       if val <= 0 then return v end
    end
end

function level.set(name)
    if not level.loaded[name] then return end
    level.current = level.loaded[name]
    for i,v in ipairs(level.loaded[name].songQueue) do
        soundQueue:queue(music[v])
    end
end
level.timer = 0

level.nextSpawnTime = 0
local spawnTimer = 1

function  level.update(dt)
    level.timer = level.timer +dt

    spawnTimer = spawnTimer - dt
    
    if spawnTimer <= 0 then
        local enemy = getRandomWeigthedElement(level.current.enemies)
        if enemy then
            local x = love.math.random()*64
            if not enemies[enemy[1]] then print("enemy not found") else
            gamestate.entities.entities:insert(enemies[enemy[1]].new(enemy[3]))
            spawnTimer = love.math.random()*(level.current.maxSpawnTime-level.current.minSpawnTime) + level.current.minSpawnTime
            end
        end
    end


    if level.timer > level.current.duration+1 then
        level.set(level.current.next)
        soundQueue:play()
    end
end

function  level.spawnEntities()

end

return level