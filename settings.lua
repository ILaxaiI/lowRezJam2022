local ffi = require("ffi")
ffi.cdef([[
    typedef struct settings_struct {
        float sfxVolume,
        musicVolume;
} settings_struct;]])

local settingsMT = {}
settingsMT.__index = settingsMT

function settingsMT:load()
    local s =  love.filesystem.read("data","settings")
    if not s then
        self:save()
        return
    end
    self[0] = ffi.cast("settings_struct*",s:getFFIPointer())[0]
end

function  settingsMT:save()
    love.filesystem.write("settings",self.data)
end


local settings = love.data.newByteData(ffi.sizeof("settings_struct"))
local settingsptr = ffi.cast("settings_struct*",settings:getFFIPointer())
settingsptr.sfxVolume = .3
settingsptr.musicVolume = 1
settingsMT.data = settings

ffi.metatype(ffi.typeof("settings_struct"),settingsMT)
return settingsptr

