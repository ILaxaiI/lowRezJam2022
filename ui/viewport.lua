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

function  viewport.translate(x,y)
    local scale = viewport.scale    
    return x/scale - viewport.offsetx,y/scale - viewport.offsety
end



function viewport.beginRender()
    love.graphics.setCanvas(viewport.canvas)
    love.graphics.clear(0,0,.1)
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