---@class MoveController
local Ctrller = class("MoveController")

Ctrller.State = {
    Walking = 0,
    Stop = 1
}

function Ctrller:ctor(master)
    self.master = master
    self:Init()
end

function Ctrller:Init()
    local px, pz = self.master.sess.map:TryCreateUnit(self.master)
    self.position = {
        x = px,
        z = pz
    }
    self.curState = Ctrller.State.Stop
end

function Ctrller:MoveToPos(x, z)
    self.master.sess.map:UnitReqMove(self, {x = x, z = z})
end

return Ctrller
