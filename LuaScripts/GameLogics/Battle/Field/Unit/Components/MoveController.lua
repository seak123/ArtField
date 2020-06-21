---@class MoveController
local Ctrller = class("MoveController")

Ctrller.State = {
    Walking = 0,
    Stop = 1
}

function Ctrller:ctor(master)
    self.master = master
    self:Init()
    self.moving = false
end

function Ctrller:Init()
    local px, pz = self.master.sess.map:TryCreateUnit(self.master)
    self.position = {
        x = px,
        z = pz
    }
    self.viewPosition = self.master.sess.map:GetMapGridCenter(self.position.x,self.position.z)
    self.curState = Ctrller.State.Stop
end

function Ctrller:MoveToPos(x, z)
    return self.master.sess.map:UnitReqMove(self, {x = x, z = z})
end

return Ctrller
