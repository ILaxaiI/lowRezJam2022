
local vec2 ={}


local cos,sin = math.cos,math.sin

function vec2.scalar(x1,y1,x2,y2) return x1*x2+y1*y2 end

function vec2.length(x,y)
    if x~= 0 or y~= 0 then
        return math.sqrt(x*x+y*y)
    else
        return 0
    end
end

function vec2.unit(x,y)
    if x~= 0 or y ~= 0 then
        local len = math.sqrt(x*x+y*y)
        return x/len,y/len
    else
        return 0,0
    end
end

function vec2.project(x1,y1,x2,y2)
    x2,y2 = vec2.unit(x2,y2)
    local s = vec2.scalar(x1,y1,x2,y2)/vec2.scalar(x2,y2,x2,y2)
    return s*x2,s*y2
end

function vec2.getNormal(x,y)
    return y,-x
end

function  vec2.rotate(x,y,a)
    local c,s = cos(a),sin(a)
    local x2 = x*c - y*s
    local y2 = x*s + y*c
    return x2,y2
end

return vec2