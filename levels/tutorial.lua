local tut = {
    name = "tutorial",next = "level1",
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
            }
        },
        --randomEnemies = {},
    },

    {
        advance = {progress = {"cannon_purchased","tutorial_asteroid_destroyed",op = "AND"}},
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

    
    {
        advance = {duration = 10},--progress = {"cannon_purchased","tutorial_asteroid_destroyed",op = "AND"}},
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