local text = {}
text.__index = text

text.font = love.graphics.newImageFont("graphics/menus/font.png","0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.,!? ",1)
love.graphics.setFont(text.font)


function  text:draw()
    if type(self.txt) == "number" then
        love.graphics.print(self.txt,self.x,self.y)
        --   text.printNumber(self.txt,self.x,self.y,self.pad)
    end
end

function text.new(txt,x,y)
    return setmetatable({txt = txt,x=x,y=y},text)
end

return text