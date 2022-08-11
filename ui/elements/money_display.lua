--local font = love.graphics.newImageFont("graphics/menus/tiny_numbers_font.png","0123456789-.+",1)
--local text = require("ui.elements.text")

local font = require("ui.elements.text").font
local money_display = {}
money_display.__index = money_display

local animation = require("util.animation")
local q = love.graphics.newQuad
local coin = animation:new(
  love.graphics.newImage("graphics/menus/coin.png"),
{q(0,0,4,4,12,4),q(6,0,3,4,12,4),q(11,0,1,4,12,4)},
{

  {d=.25,quadId = 1,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
  {d=.25,quadId = 3,ox = 2,oy = 0,r = 0,sx = 1,sy = 1},
  {d=.25,quadId = 1,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
  {d=.25,quadId = 3,ox = 1,oy = 0,r = 0,sx = 1,sy = 1},


}

)
coin:start()
coin:setLoop(true)

function money_display:new(n,x,y,anim)
    local m = {n = n,x = x,y = y}
    if not anim then
      m.anim = coin:create()
    end
    return setmetatable(m,self)
end

function money_display:update(dt)
  if self.anim then
    self.anim:update(dt)
  end
end

function  money_display:draw()
  --  love.graphics.setFont(font)
    local dx = font:getWidth(self.n)
    if self.anim then
      self.anim:draw(self.x-dx-5,self.y+1)
    end
    love.graphics.print(self.n,self.x-dx,self.y)
    --love.graphics.setFont(text.font)
end
return money_display