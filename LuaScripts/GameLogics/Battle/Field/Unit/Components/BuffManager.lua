---@class BuffManager
local Mng = class("BuffManager")

function Mng:ctor(master)
    self.master = master
    self:Init()
   
end

function Mng:Init()
end

function Mng:Update(delta)
end

return Mng
