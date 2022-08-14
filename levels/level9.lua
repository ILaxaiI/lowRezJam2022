return {
    next = "boss_2",
    name = "level9",
    music = {"loop5_intro","loop5"},

    sections = {{
        advance = {duration = 90},
    minSpawnTime = .3,
    maxSpawnTime = .8,

    randomEnemies = {
        {"black_hole",.1},{"asteroid",.2,26},{"large_asteroid",.3,2},{"radiation",.01,24},{"scout_ship",.2},{"bomber",.12},{"gamma_ray",.07,10},
    }
    }}
}