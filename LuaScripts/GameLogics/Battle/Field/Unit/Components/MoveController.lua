---@class MoveController
local Ctrller = class("MoveController")

function Ctrller:ctor(master)
    self.master = master
end

return Ctrller