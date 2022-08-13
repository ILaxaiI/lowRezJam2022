local tut = {
    name = "tutorial",next = "boss",
    sections = {
       {
        advance = {progress = {"tutorial_asteroid_dodged",op = "OR"}},
        loop = {duration = 6},
        songQueue = {},
        enemies = {
            {
                name = "tutorial_asteroid",
                spawns = {
                    {t = 1.5, x = 32,y = -5,sv = 15}
                }
            },
        },
    },
    
    {
        advance = {progress = {"cannon_purchased",op = "AND"}},
        --loop = {duration = 10},
        songQueue = {},
        minSpawnTime = 2,
        maxSpawnTime = 2,
        randomEnemies = {
            {"tutorial_asteroid",1,20}
        },
    },

    
    {
        advance = {progress = {"tutorial_asteroid_destroyed",op = "AND"}},--progress = {"cannon_purchased","tutorial_asteroid_destroyed",op = "AND"}},
        --loop = {duration = 10},
        songQueue = {},
        --[[enemies = {
            {
                name = "asteroid",
                spawns = {
                    {t = 1.5, x = 32,y = -5,sv = 15}
                }
            }
        }]]
        minSpawnTime = 2,
        maxSpawnTime = 2,
        randomEnemies = {{"tutorial_asteroid",1,20}},
    },
    }
}


return tut