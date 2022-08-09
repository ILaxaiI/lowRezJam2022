--local font = love.graphics.newImageFont("graphics/menus/tiny_numbers_font.png","0123456789-.+",1)
--local text = require("ui.elements.text")

local font = require("ui.elements.text").font
local money_display = {}
money_display.__index = money_display


function money_display:new(n,x,y)
    local m = {n = n,x = x,y = y}
    return setmetatable(m,self)
end



function  money_display:draw()
  --  love.graphics.setFont(font)
    love.graphics.print(self.n,self.x-font:getWidth(self.n),self.y)
    --love.graphics.setFont(text.font)
end
return money_display