local text = {}
text.__index = text
text.font = love.graphics.newImageFont("graphics/menus/font_o.png",[[0123456789-.+!?'",;:/ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz|[] ]],1)

love.graphics.setFont(text.font)


function  text:draw()
        love.graphics.print(self.txt,self.x,self.y)
        --   text.printNumber(self.txt,self.x,self.y,self.pad)
end

function text:new(txt,x,y)
    return setmetatable({txt = txt,x=x,y=y},text)
end

return text