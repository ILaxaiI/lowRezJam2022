local viewport = {
    canvas = love.graphics.newCanvas(64,64)
}
function  viewport.getScale()
    return math.min(love.graphics.getWidth()/viewport.canvas:getWidth(),love.graphics.getHeight()/viewport.canvas:getWidth())
end

function  viewport.getOffset()
    local scale = viewport.getScale()
    local offsetx = .5*(love.graphics.getWidth() - love.graphics.getHeight())/scale
    local offsety = .5*(love.graphics.getHeight() - love.graphics.getWidth())/scale

    if offsetx < offsety then
        offsetx = 0
    else
        offsety = 0
    end
    
    return offsetx,offsety
end
local seed
for i = 1,100 do seed = love.math.random() end

local background = love.image.newImageData(64,64)

for x = 0,63 do
    for y = 0,63 do
        background:setPixel(x,y,
        .03*love.math.noise(x*.051,y*.02,seed)+.01*love.math.noise(x*.0921,y*.0932,seed)+.02*love.math.noise(x*.551,y*.5532,seed),
        .04*love.math.noise(x*.012,y*.036,seed)+.03*love.math.noise(x*.0931,y*.0942,seed)+.02*love.math.noise(x*.571,y*.542,seed),
        .06+.07*love.math.noise(x*.032,y*.022,seed)+.03*love.math.noise(x*.0911,y*.0932,seed+.03*love.math.noise(x*.5511,y*.532,seed))
        
    )
    end
end

background = love.graphics.newImage(background)
function viewport.beginRender()
    love.graphics.setCanvas(viewport.canvas)

    love.graphics.clear(0,0,.1)
    love.graphics.draw(background)
end

function  viewport.endRender()
    love.graphics.setCanvas()
end

function  viewport.draw()
    love.graphics.push()
    love.graphics.scale(viewport:getScale())
    local offsetx,offsety = viewport.getOffset()
    love.graphics.draw(viewport.canvas,offsetx,offsety)
    love.graphics.pop()
end

return viewport