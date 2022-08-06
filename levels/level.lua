local level = {}
level.loaded = {
    [0] = {name = "intro",next = "level1",duration = 3,
    songQueue = {},enemies = {}
    },
    level1 = require("levels.level1"),
    level2 = require("levels.level2"),
    level3 = require("levels.level3"),
    level4 = require("levels.level4")
}

local gamestate = require("gamestate")
level.current = level.loaded[gamestate.currentLevel]


local music = require("audio.music")

local enemies = require("entities.enemies")
local soundQueue = music.source



local function  getRandomWeigthedElement(ents)
    local val = love.math.random()
    for i,v in ipairs(ents) do
       val = val - v[2]
       if val <= 0 then return v end
    end
end

level.timer = 0
level.nextSpawnTime = 0
local spawnTimer = 1
function level.set(name)
    if not level.loaded[name] then return end
    level.current = level.loaded[name]
    gamestate.currentLevel = level.current
    level.timer = 0
    soundQueue:stop()
    for i,v in ipairs(level.loaded[name].songQueue) do
        soundQueue:queue(music[v])
    end
    soundQueue:play()
end

function  level.update(dt)
    level.timer = level.timer +dt
    level.spawnEntities(dt)
    if level.current.update then
        level.current:update(dt)
    end


    if level.timer > level.current.duration+1 then
        level.set(level.current.next)
        soundQueue:play()
    end
end

function level.draw()
    if level.current.draw then
        level.current:draw()
    end
end

function  level.spawnEntities(dt)
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
end

return level