local state = {}
state.list = {}
state.current = false
local nul = function () end
function  state.load(filepath,name)
    state.list[name or filepath] = assert(require(filepath),"filepath did not return table")
end

function state.set(name,...)
    state:exit()
    state.current = assert(state.list[name] and name,"gamestate could not be found")
    state:init(...)
end


return setmetatable(state,{__index = function (tab,key) return (state.list[state.current] and state.list[state.current][key]) or nul end})