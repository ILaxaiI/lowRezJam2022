return {
    next = "level4",
    name = "level3",
    music = {{"loop2",loop = true}},
    sections = {{
        advance = {duration = 35},
        minSpawnTime = .8,
        maxSpawnTime = 1.6,
        randomEnemies = {
            {"asteroid",.65,24},{"radiation",.25,24},{"solar_flare",.1,10}
        }
    }}
}