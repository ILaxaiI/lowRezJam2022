local animation = {}
animation.__index = animation


--[[
    callbacks = {
        onStart
        onEnd
}
]]


--[[
    frame = {
        d
        quadId
        ox
        oy
        r
        sx
        sy
    }
]]
function  animation.new(sprite,quads,frames)
    local duration = 0
    for i,v in ipairs(frames) do
        duration = duration + v.d
    end

    local a = {
        ox = 0,oy = 0,
        sprite = sprite,
        quads = quads,
        frames = frames,
        timer = 0,
        duration = duration,
        currentFrame = 1
    }
    a.__index = a


    return setmetatable(a,animation)
end

function  animation:setCallback(name,funk,args)
    self.callbacks = self.callbacks or {}
    self.args = self.args or {}
    
    self.callbacks[name] = funk
    self.args[name] = args

end
function animation:call(callback,...)
    if self.callbacks and self.callbacks[callback] then
        self.callbacks[callback](self,self.args[callback],...)
    end
end

function  animation:create()
    return setmetatable({},self)
end

function  animation:setLoop(l)
    self.loop = l
end

function  animation:start()
    self.timer = 0
    self.currentFrame = 1
    self:call("onStart")
    self:call("onFrame",1)
    self.playing = true
end

local function emtpy() end

function animation:update(dt)
    if self.playing then
        self.timer = self.timer + dt
        if self.timer >= self.frames[self.currentFrame].d then
            self.timer = self.timer - self.frames[self.currentFrame].d
            self.currentFrame = self.currentFrame + 1
           
        end
        if self.currentFrame > #self.frames then
          
            if type(self.loop) == "number" then
                self.loop = self.loop - 1
                self.playing = self.loop > 0
            else
                self.playing = self.loop
            end
            self.currentFrame = 1
            if not self.playing then
                self:call("onEnd")
            end
        else
            self:call("onFrame",self.currentFrame)
        end
    end
end

local detached = {}


function  animation:removeDetached()
    if self.animId then
        detached[self.animId] = detached[#detached]
        if detached[self.animId] then
           detached[self.animId].animId = self.animId
        end
    end

end

function  animation:startDetached(x,y)
    self.ox = x
    self.oy = y
    self:setCallback("onEnd",animation.removeDetached)
    local id = #detached+1
    self.animId = id
    detached[#detached+1] = self
    self:start()

end

function animation.updateDetached(dt)
    for i = #detached,1,-1 do
        detached[i]:update(dt)
    end
end
function animation.drawDetached()
    for i,v in ipairs(detached) do
        v:draw(0,0)
    end
end
function animation.clearDetached()
    detached={}
end

function animation:draw(x,y)
    if self.playing then
        local frame = self.frames[self.currentFrame]
        love.graphics.draw(self.sprite,self.quads[frame.quadId],frame.ox+x+self.ox,frame.oy+y+self.oy,frame.r,frame.sx,frame.sy)
    end
end

return animation