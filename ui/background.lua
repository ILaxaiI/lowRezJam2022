local background=  {}
local star = love.graphics.newImage("graphics/star.png")
local stars = love.graphics.newParticleSystem(star,1000)

stars:setDirection(0,1)
stars:setEmissionRate(4)
stars:setEmissionArea("uniform",64,1,0,false)

stars:setParticleLifetime(30)
stars:setDirection(math.pi/2)
stars:setSpeed(8,8)
stars:setSizes(1)
stars:start()
for i = 1,40 do
    stars:update(1)
end
local backcanv = love.image.newImageData(64,64)

local seed
for i = 1,100 do seed = love.math.random() end

for x = 0,63 do
    for y = 0,63 do
        backcanv:setPixel(x,y,
        .035*love.math.noise(x*.051,y*.02,seed)+.015*love.math.noise(x*.0921,y*.0932,seed)+.025*love.math.noise(x*.551,y*.5532,seed),
        .045*love.math.noise(x*.012,y*.036,seed)+.035*love.math.noise(x*.0931,y*.0942,seed)+.025*love.math.noise(x*.571,y*.542,seed),
        .06+.075*love.math.noise(x*.032,y*.022,seed)+.035*love.math.noise(x*.0911,y*.0932,seed+.035*love.math.noise(x*.5511,y*.532,seed))
        
    )
    end
end


--backcanv:encode("png","bckrnd.png")

backcanv = love.graphics.newImage(backcanv)


function  background.draw()
    
    love.graphics.draw(backcanv)
    love.graphics.draw(stars,0,-2)
end

function background.update(dt)
    stars:update(dt)
end

return background