local overlap = {

}
function overlap.aabb(x1,y1,w1,h1,x2,y2,w2,h2)
    return  x1+w1 > x2 and x2+w2 > x1
    and     y1+h1 > y2 and y2+h2 > y1
end

local vec2 = require("util.vec2")
function overlap.lineAABB(x1,y1,x2,y2, x3,y3,w3,h3)
    -- x axis overlap
    x = vec2.project(x2-x1,y2-y1,1,0)
    _,y = vec2.project(x2-x1,y2-y1,0,1)
    
    return x1 < x3+w3 and x+x1 >x3 and y1 < y3+h3 and y+y1 > y3 
end

return overlap