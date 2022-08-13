local boss = {
    name = "boss",
    next = "level9",
    sections = {
        {
    advance = {scripted = true},
    enemies = {
        {
            name = "large_ship",
            spawns = {
                {t = 0, x = 32-20,y = 5,sv = 15}
            }
        },
    },
    songQueue = {
        "intro"
    },
    minSpawnTime = .5,
    maxSpawnTime = 2,

},
{
    advance = {scripted = true},
    songQueue = {
        "intro"
    },
    minSpawnTime = 2,
    maxSpawnTime = 4,
    randomEnemies = {{"scout_ship",.8,18},{"bomber",.2,18}}
},
{
    advance = {progress = {"boss_beaten",op = "OR"}},
    songQueue = {
        "intro"
    },
    minSpawnTime = 1,
    maxSpawnTime = 1.5,
    randomEnemies = {{"scout_ship",.5,18},{"bomber",.5,18}}
}
}
}

return boss