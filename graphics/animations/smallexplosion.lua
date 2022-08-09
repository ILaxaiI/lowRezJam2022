local animation = require("util.animation")
local esp = require("graphics.sprites").explosion
local iw,ih = esp:getDimensions()
local nq = love.graphics.newQuad
local explosion = animation:new(esp,
{[0] =nq(0,10,5,5,iw,ih),nq(5,10,5,5,iw,ih),nq(10,10,5,5,iw,ih)},
{
    {d=.08,quadId = 0,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
    {d=.08,quadId = 1,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
    {d=.08,quadId = 2,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
}
)

return explosion