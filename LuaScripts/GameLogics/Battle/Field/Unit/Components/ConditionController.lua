---@class ConditionController
local Ctrller = class("ConditionController")

Ctrller.StateType = {
    Dizzy = 2 ^ 0, --眩晕
    Steal = 2 ^ 1 --隐身
}

function Ctrller:ctor(master)
    self.master = master
    self:Init()
    self.state = 0
    self.stateCount = {}
end

function Ctrller:Init()
end

function Ctrller:AddState(state)
    if self.stateCount[state] == nil then
        self.stateCount[state] = 0
    end
    self.stateCount[state] = self.stateCount[state] + 1
    self.state = Math.bitOR(self.state,state)
end

function Ctrller:RemoveState(state)
    if self.stateCount[state] == nil then
        self.stateCount[state] = 0
    end
    self.stateCount[state] = math.max(0, self.stateCount[state] - 1)
    if self.stateCount[state] == 0 then
        self.state = Math.bitAND(self.state,Math.bitNOT(state))
    end
end

function Ctrller:hasState(state)
    return Math.bitAND(self.state, state) > 0
end

return Ctrller
