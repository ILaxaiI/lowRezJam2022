local gamestate = require("gamestate")
local large_ship = require("entities.entity"):extend()
large_ship.sprite = require("graphics.sprites").ship_atlas
large_ship.quads = {
    phase1 = love.graphics.newQuad(0,50,40,20,large_ship.sprite:getDimensions()),
    phase2 =  love.graphics.newQuad(53,35,40,20,large_ship.sprite:getDimensions()),
    phase3 =  love.graphics.newQuad(53,13,40,20,large_ship.sprite:getDimensions())}

large_ship.health_sprite = require("graphics.sprites").boss_health

large_ship.speed = 15
large_ship.health_sprite:setWrap("repeat")
large_ship.w = 40
large_ship.h = 20
large_ship.type ="ship"
large_ship.money = 100


local nq = love.graphics.newQuad

local animation = require("util.animation")
local iw,ih = large_ship.sprite:getDimensions()
large_ship.thrusterAnim = {
    phase1 = animation:new(
    large_ship.sprite,
    {nq(0,24,40,7,iw,ih),nq(0,32,40,7,iw,ih),nq(0,40,40,7,iw,ih)},
    {
        {d=.2,quadId = 1,ox = 0,oy =-2,r = 0,sx = 1,sy = 1},
        {d=.2,quadId = 2,ox = 0,oy = -2,r = 0,sx = 1,sy = 1},
        {d=.2,quadId = 3,ox = 0,oy = -2,r = 0,sx = 1,sy = 1},
    }),
    phase2 = animation:new(
    large_ship.sprite,
    {nq(18,40,4,5,iw,ih),nq(18,32,4,5,iw,ih),nq(18,24,4,5,iw,ih)},
    {
        {d=.2,quadId = 1,ox = 18,oy =-2,r = 0,sx = 1,sy = 1},
        {d=.2,quadId = 2,ox = 18,oy = -2,r = 0,sx = 1,sy = 1},
        {d=.2,quadId = 3,ox = 18,oy = -2,r = 0,sx = 1,sy = 1},
    }),
}

large_ship.thrusterAnim.phase1:start()
large_ship.thrusterAnim.phase1:setLoop(true)
large_ship.thrusterAnim.phase2:start()
large_ship.thrusterAnim.phase2:setLoop(true)


large_ship.laserFirerate = 7
large_ship.missileFirerate = 5

local statesMt = {}
statesMt.__index = statesMt

local states = {
    spawning =  require("entities.ships.large_ship_states.spawning"),
    idle =      require("entities.ships.large_ship_states.idle"),
    laser =     require("entities.ships.large_ship_states.laser"),
    missile =   require("entities.ships.large_ship_states.missile"),
    beam =      require("entities.ships.large_ship_states.beam"),
    damage1 =   require("entities.ships.large_ship_states.damage1"),
    damage2 =   require("entities.ships.large_ship_states.damage2")
}
for i,v in pairs(states) do setmetatable(v,statesMt) end
function  statesMt.transition(ai,name,entity)
    if states[name] then
        if states[name].init then
            states[name].init(ai,entity)
        end
        setmetatable(ai,states[name])
    end
end

function  statesMt.Forcetransition(ai,name,entity)
    if ai.interupt then ai.interupt(ai,entity) end
    if states[name] then
        if states[name].init then
            states[name].init(ai,entity)
        end
        setmetatable(ai,states[name])
    end
end

large_ship.hq = love.graphics.newQuad(0,0,1,1,2,1)
large_ship.maxHealth = 500
large_ship.money = 1000



local barrel = 1





function large_ship:new()
    --local x,y = large_ship:getRandomSpawn()
    local x = 32-20
    local y = -22
    gamestate.progressFlags.boss_beaten = false
    return setmetatable({
        x = x,
        y = y,
        r = 0,
        maxHealth = 2000,--40*(5+gamestate.stats.cannon_firerate*gamestate.stats.cannon_damage),
        health = 2000,--40*(5+gamestate.stats.cannon_firerate*gamestate.stats.cannon_damage),
        vx = 0,
        vy = 0,
        spawning = true,
        anim = {large_ship.thrusterAnim.phase1:create(),large_ship.thrusterAnim.phase2:create()},

        ai = setmetatable({phase = "phase1",target = {x = x}},states.spawning),

        lifetime = 0
    },self)

end

local bullet = require("entities.bullets.green_laser")



function  large_ship:update(dt)
    if self.ai.phase == "phase1" then
        self.anim[1]:update(dt)
    else
        self.anim[2]:update(dt)
    end

    self.lifetime = self.lifetime +dt
    self.ai:update(self,dt)

    if self.ai.target.x then
        local dx = self.x - self.ai.target.x
        if  math.abs(dx) > 1 and dx ~= 0 then
            self.x = self.x - math.abs(dx)/dx*dt*self.speed
        else
            self.ai.target.x = false
        end
    end
end



function large_ship:takeDamage(dmg)
    if self.ai.damageAble then
        self.health = self.health - dmg
        if self.health <= 0 then
            if self.ai.phase == "phase1" then
                self.maxHealth = 1900
                self.ai.Forcetransition(self.ai,"damage1",self)
                gamestate.currentSection = gamestate.currentSection + 1
            elseif self.ai.phase == "phase2" then
                self.maxHealth = 1800
                self.ai.Forcetransition(self.ai,"damage2",self)
                gamestate.currentSection = gamestate.currentSection + 1
            else
                self.ai.Forcetransition(self.ai,"idle",self)
                self:die()
            end
        end
    end
end
function  large_ship:draw()
    if self.ai.phase == "phase1" then
        self.anim[1]:draw(self.x,self.y)
    else 
        self.anim[2]:draw(self.x,self.y)
    end

    love.graphics.draw(self.sprite,self.quads[self.ai.phase],self.x+20,self.y+10,self.r,1,1,20,10)
    self.ai:draw(self)
end
large_ship.hitboxes = {
    phase1 = {{x=0,y=4,w=5,h=12},{x=35,y=4,w=5,h=12},
        {x=7,y=2,w=6,h=11},{x=27,y=2,w=6,h=11},
        {x=15,y=0,w=10,h=20}},
    phase2 = {{x=0,y=4,w=5,h=12},{x=35,y=4,w=5,h=12},
        {x=7,y=2,w=6,h=11},{x=27,y=2,w=6,h=11},
        {x=15,y=0,w=10,h=20}},
    phase3 ={{x=15,y=0,w=10,h=20}}}

    local overlap = require("util.overlap")
function  large_ship.overlap(e1,e2)
    local x1 = e1.x + (e1.aabbxo or 0)
    local y1 = e1.y + (e1.aabbyo or 0)
    for i,v in ipairs(large_ship.hitboxes[e2.ai.phase]) do
        if overlap.aabb(x1,y1,e1.w,e1.h,e2.x+v.x,e2.y+v.y,v.w,v.h) then
            return true
        end
    end
end


local explosion = require("graphics.animations.explosion")
function  large_ship:die(payout)
    if payout then
        gamestate.player.money = gamestate.player.money + large_ship.money
    end
    gamestate.progressFlags.boss_beaten = true
    animation.startDetached(explosion:create(),self.x,self.y)

    self.isDead = true
end


return large_ship