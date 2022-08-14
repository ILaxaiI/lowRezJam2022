local level = {}
level.loaded = {
    tutorial = require("levels.tutorial"),
    level1 = require("levels.level1"),
    level2 = require("levels.level2"),
    level3 = require("levels.level3"),
    level4 = require("levels.level4"),
    level5 = require("levels.level5"),
    level6 = require("levels.level6"),
    level7 = require("levels.level7"),
    level8 = require("levels.level8"),
    boss = require("levels.boss"),
    level9 = require("levels.level9")
}

local gamestate = require("gamestate")



local enemies = require("entities.enemies")

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

local music = require("audio.music")

function level.resetSpawned()
    for i,section in ipairs(level.current.sections) do
        if section.enemies then
        for i,v in ipairs(section.enemies) do
            for i2,v2 in ipairs(v.spawns) do
                v2.spawned = false
            end
        end
    end
end
end
level.currentMusic = false
level.musicIndex = 1
local settings = require("settings")


function level.set(name)
    if not level.loaded[name] then print("level does not exist") return end


    if level.current then
        local cs = level.current.music[level.songindex]
    
        if level.loaded[level.current.next].music[level.songIndex+1] == cs then
            level.songIndex = 1
        else
            level.songIndex = 0
        end

    else
        level.songIndex = 0
    end

    gamestate.currentSection = 1

    level.current = level.loaded[name]
    gamestate.currentLevel = level.current

    level.timer = 0
    level.resetSpawned()
end


local compare = {
    AND = function (a,b)
        return a and b
    end,
    OR = function (a,b)
        return a or b
    end}

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
    end,
    beaten = function (data,allSpawned)
        if data == "all" then
            return allSpawned
        end
    end}

local loop = {
    duration = function (data)
        return level.timer >= data
    end}


local progressTimer = 0
local p = false
function level.progress(section,...)
    for i,v in pairs(section.advance) do
        if prog[i] and prog[i](v,...) then
            if level.current.sections[gamestate.currentSection+1] then
                gamestate.currentSection = gamestate.currentSection + 1
                level.timer = 0
            else
                progressTimer = 5
                p = true
            end
        end
    end

    if not section.loop then return end
    for i,v in pairs(section.loop) do
        if loop[i] and loop[i](v) then
            level.timer = 0
            level.resetSpawned()
        end
    end
end

function level.updateMusic()
    if not level.currentMusic then
        level.currentMusic = level.getNextSong()
        if music[level.currentMusic] then
            music[level.currentMusic]:setVolume(settings.musicVolume)
            music[level.currentMusic]:play()
        end
    end
    if music[level.currentMusic] and not music[level.currentMusic]:isPlaying() then
        level.currentMusic = level.getNextSong()
            music[level.currentMusic]:setVolume(settings.musicVolume)
            music[level.currentMusic]:play()
    end
    
end

function  level.update(dt)
    local section = level.current.sections[gamestate.currentSection]

    if not p then
        level.updateMusic()

        if section.randomEnemies then
            level.spawnRandomEntities(section,dt)
        end
        local allSpawned = level.spawnScriptedEntities(section,dt)
        level.timer = level.timer +dt
        level.progress(section,allSpawned)
    else
        progressTimer = progressTimer - dt
        if level.current.name == "boss" then
           music[level.currentMusic]:setVolume(settings.musicVolume * (math.lerpc(.5,1,progressTimer/5)))
        end
        if progressTimer <= 0 then
            music[level.currentMusic]:stop()
            p = false
            level.set(level.current.next)
        end
    end
end



function level.draw()
    if level.current.draw then
        level.current:draw()
    end
end


function level.spawnScriptedEntities(section,dt)
    local allSpawned = true
    if section.enemies then
        for i,v in ipairs(section.enemies) do
            for i2,v2 in ipairs(v.spawns) do
                if not v2.spawned or (v2.spawned and not v2.spawned.isDead) then allSpawned = false end
                if level.timer+dt >= v2.t and not v2.spawned then
                    local enemy = enemies[v.name]:new(v2.sv)
                    enemy.x = v2.x
                    enemy.y = v2.y
                    gamestate.entities.entities:insert(enemy)
                    v2.spawned = enemy
                end
            end
        end
    end
    return allSpawned
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

level.songIndex = 0

function  level.getNextSong()
    if level.current and level.current.music[level.songIndex+1] then
        level.songIndex = level.songIndex + 1
    end
    return level.current and level.current.music[level.songIndex]
end


return level