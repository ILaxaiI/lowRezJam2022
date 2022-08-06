local button = {}
button.__index = button

function  button.new(sprite,quads,x,y,w,h,func,args)
    return setmetatable({
        sprite = sprite,
        quads = quads,
        x = x,y = y,w = w,h = h,
        func = func,
        args = args,
        pressed = false,
    },button)
end


function button:clicked(x,y)
    if x >= self.x and x <= self.x+self.w and y >= self.y and y <= self.y+self.h then
        self.pressed = true
    end
end

function button:released(x,y)
    if self.pressed and self.func and x >= self.x and x <= self.x+self.w and y >= self.y and y <= self.y+self.h then
        self.func(self.args)
    end
    self.pressed = false
end

function button:draw()
    local quad = not self.pressed and self.quads[1] or (self.quads[2] or self.quads[1])
    love.graphics.draw(self.sprite,quad,self.x,self.y)
end

return button