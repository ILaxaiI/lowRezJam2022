local l1 = {
    name = "level1",
    next = "level2",
    sections = {
        {
    advance = {duration = 45},
    songQueue = {
        "intro"
    },
    minSpawnTime = .5,
    maxSpawnTime = 2,

    randomEnemies = {
        {"asteroid",1,20}
    }
}
}
}

return l1