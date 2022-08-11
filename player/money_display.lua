
local gamestate = require("gamestate")
local ndisp = require("ui.elements.money_display"):new(gamestate.player.money,62,3)

function ndisp:update(dt)
    self.anim:update(dt)
    self.n = tostring(gamestate.player.money)
end
return ndisp
