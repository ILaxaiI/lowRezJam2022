local level = {}
level.loaded = {
    [0] = require("levels.tutorial"),
--    level1 = require("levels.level1"),
--    level2 = require("levels.level2"),
--    level3 = require("levels.level3"),
--    level4 = require("levels.level4")
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
    if not level.loaded[name] then print("level does not exist") return end
    gamestate.currentSection = 1
    level.current = level.loaded[name]
    gamestate.currentLevel = level.current
    level.timer = 0

end
local compare = {
    AND = function (a,b)
        return a and b
    end,
    OR = function (a,b)
        return a or b
    end
}

local prog = {
    progress = function (data)
        local bool
        for i,v in ipairs(data) do
            if bool == nil then
                bool =gamestate.progressFlags[v]
            else
                bool = compare[data.op](bool,gamestate.progressFlags[v])
            end
        end
        return bool
    end,
    duration = function (data)
        return level.timer >= data
    end
}

local loop = {
    duration = function (data)
        return level.timer >= data
    end
}

function level.progress(section)

    for i,v in pairs(section.advance) do
        if prog[i] and prog[i](v) then
            if level.current.sections[gamestate.currentSection+1] then
                gamestate.currentSection = gamestate.currentSection + 1
                level.timer = 0
            else
                level.set(level.current.next)
            end
        end
    end



    if not section.loop then return end
    for i,v in pairs(section.loop) do
        if loop[i] and loop[i](v) then
            level.timer = 0
        end
    end
end

function  level.update(dt)
    local section = level.current.sections[gamestate.currentSection]
  
    if section.randomEnemies then
        level.spawnRandomEntities(section,dt)
    end
    if section.enemies then
    for i,v in ipairs(section.enemies) do
        for i2,v2 in ipairs(v.spawns) do
            if level.timer <= v2.t and level.timer+dt >= v2.t then
                local enemy = enemies[v.name]:new(v2.sv)
                
                enemy.x = v2.x
                enemy.y = v2.y

                gamestate.entities.entities:insert(enemy)
            end
        end
    end
end

    level.timer = level.timer +dt
    level.progress(section)

--    if level.timer > level.current.duration+1 then
--        level.set(level.current.next)
--        soundQueue:play()
--    end
end

function level.draw()
    if level.current.draw then
        level.current:draw()
    end
end

function  level.spawnRandomEntities(section,dt)
    spawnTimer = spawnTimer - dt
    if spawnTimer <= 0 then
        local enemy = getRandomWeigthedElement(section.randomEnemies)
        if enemy then
            local x = love.math.random()*64
            if not enemies[enemy[1]] then print("enemy not found") else
            gamestate.entities.entities:insert(enemies[enemy[1]]:new(enemy[3]))
            spawnTimer = love.math.random()*(section.maxSpawnTime-section.minSpawnTime) + section.minSpawnTime
            end
        end
    end
end

return level