local l1 = {
    name = "level1",
    next = "level2",
    duration = 33,
    songQueue = {
        "intro"
    },
    minSpawnTime = .5,
    maxSpawnTime = 2,

    enemies = {
        {"asteroid",1,20}
    }
}

return l1