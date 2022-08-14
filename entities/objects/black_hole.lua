local distrotionTex = love.graphics.newImage(
                        love.image.newImageData(
                            201,1,"rgba16f",love.filesystem.read("data","graphics/black_hole_distort.png")))


local drawDistortBuffer = love.graphics.newShader([[
    #pragma language glsl3
    #ifdef PIXEL

    uniform Image distortion;
    vec4 effect(vec4 color,Image tex, vec2 Texcoord,vec2 sc){
        vec2 dir = Texcoord-vec2(.5,.5);
        float dist = length(dir);
        return vec4(normalize(dir)*.5*Texel(distortion,vec2(dist,.5)).r,dist < .05    ,0);
    }
    #endif
]])
drawDistortBuffer:send("distortion",distrotionTex)


local shader = love.graphics.newShader([[
#pragma language glsl3
#ifdef PIXEL
uniform Image distortBuffer;

vec4 effect(vec4 color,Image tex, vec2 Texcoord,vec2 sc){
    vec3 diff = Texel(distortBuffer,Texcoord).xyz;
   
    //float amp = max(0,length(diff.xy)*normalize(cross(vec3(diff.y,-diff.x,1),vec3(diff.xy,0))).z);

    if(diff.z>0){return vec4(0,0,0,1);}

    color.rgb = Texel(tex,Texcoord-diff.xy).rgb;//+16*vec3(.8,.5,.1)*amp;

    return color;
    
}
#endif
]])

local viewport = require("ui.viewport")
local distorBuffer = love.graphics.newCanvas(viewport.canvas:getWidth(),viewport.canvas:getHeight(),{format = "rgba16f"})

local black_hole = require("entities.entity"):extend()

local holes = {}

black_hole.w = 3
black_hole.h = 3


local cw,ch = viewport.canvas:getWidth()/2,viewport.canvas:getHeight()/2
black_hole.aabbxo = cw/2-black_hole.w/2
black_hole.aabbyo = ch/2-black_hole.h/2

black_hole.spawnRegions = {{0,-ch-1,60,-ch-1}}
black_hole.damage = 3
black_hole.collidewithplayer = true

function black_hole.clear()
    holes = {}
end

function black_hole:new(speed) 
    local x,y = black_hole:getRandomSpawn()
    local hole = {
        x = x,
        y = y,
        health = 2,
        vx = 0,
        vy = speed or 20,
    }
    holes[#holes+1] = hole
    return setmetatable(hole,self)
end

function  black_hole:draw() 
end

local holeCanv = love.graphics.newCanvas(viewport.canvas:getWidth()/2,viewport.canvas:getHeight()/2)

local buffer = love.graphics.newCanvas(viewport.canvas:getWidth(),viewport.canvas:getHeight())
function black_hole:render()

    love.graphics.setCanvas(distorBuffer)
    love.graphics.setShader(drawDistortBuffer)
    love.graphics.clear()
    local blend,alpha = love.graphics.getBlendMode()
    love.graphics.setBlendMode("add","premultiplied")
    for i,v in ipairs(holes) do
        love.graphics.draw(holeCanv,math.floor(v.x+.5),math.floor(v.y+.5))
    end
    love.graphics.setBlendMode(blend,alpha)


    shader:send("distortBuffer",distorBuffer)
    love.graphics.setShader(shader)
    love.graphics.setCanvas(buffer)
    love.graphics.clear()

    love.graphics.draw(viewport.canvas)
    love.graphics.setShader()

    love.graphics.setCanvas(viewport.canvas)
    love.graphics.clear()
    love.graphics.draw(buffer)
    love.graphics.setCanvas()
end

function black_hole:update(dt) 
    self.x = self.x + self.vx *dt
    self.y = self.y+ self.vy*dt
end

local gamestate = require("gamestate")
function black_hole:impactPlayer(dt) 
    gamestate.player.health = gamestate.player.health - self.damage*dt
end

return black_hole