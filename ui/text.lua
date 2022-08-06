local text = {}
text.__index = text
local q = love.graphics.newQuad
text.numbers = {
    [0] = q(46,57,4,8,64,64),
    [1] = q(41,57,4,8,64,64),
    [2] = q(36,57,4,8,64,64),
    [3] = q(31,57,4,8,64,64),
    [4] = q(26,57,4,8,64,64),
    [5] = q(21,57,4,8,64,64),
    [6] = q(16,57,4,8,64,64),
    [7] = q(11,57,4,8,64,64),
    [8] = q(6,57,4,8,64,64),
    [9] = q(1,57,4,8,64,64),}

local nbuffer = {}
local button_atlas = require("graphics.sprites").button_atlas
function text.printNumber(n,x,y,pad)
    local len = 0
    while n> 0 and (not pad or len < pad) do
        len = len + 1
        local didgit = n%10
        nbuffer[len] = didgit
        n = (n-didgit)/10
    end

    while pad and len < pad do
        len = len + 1
        nbuffer[len] = 0
    end
    for i = len,1,-1 do
        love.graphics.draw(button_atlas,text.numbers[nbuffer[i]],x-(i)*5,y)
    end
end

function  text:draw()
    if type(self.txt) == "number" then
        text.printNumber(self.txt,self.x,self.y,self.pad)
    end
end

function text.new(txt,x,y)
    return setmetatable({txt = txt,x=x,y=y},text)
end

return text