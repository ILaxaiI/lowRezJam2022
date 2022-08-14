return {
    next = "boss",
    name = "level8",
  
    music = {"loop4"},

    sections = {{
        advance = {duration = 45},
 
    
    minSpawnTime = .5,
    maxSpawnTime = 1.3,

    randomEnemies = {
        {"radiation",.1,24},{"solar_flare",.1,10},{"scout_ship",.5},{"bomber",.25},{"gamma_ray",.05,10},
    }
    }}
}