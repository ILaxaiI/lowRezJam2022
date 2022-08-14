local l1 = {
    name = "level1",
    next = "level2",
    music = {{"transition",loop = false},{"loop1",loop = true}},
    sections = {
        {
    advance = {duration = 35},
    minSpawnTime = .5,
    maxSpawnTime = 2,

    randomEnemies = {
        {"asteroid",1,20}
    }
}
}
}

return l1