local boss = {
    name = "boss",
    next = "level9",
    music = {"boss_intro2","boss2","boss3"},
    sections = {
        {
            advance = {scripted = true},
            enemies = {
                {
                name = "large_ship",
                spawns = {{t = 0, x = 32-20,y = 5,sv = 2100}}
                },
            }
        },
        {
            advance = {scripted = true},
            minSpawnTime = 2,
            maxSpawnTime = 4,
            randomEnemies = {{"scout_ship",.8,18},{"bomber",.2,18}}
        },
        {
            advance = {progress = {"boss_beaten",op = "AND"}},
            minSpawnTime = 1,
            maxSpawnTime = 1.5,
            randomEnemies = {{"scout_ship",.5,18},{"bomber",.5,18}}
        }
    }
}

return boss