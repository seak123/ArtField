local base = require("GameLogics.Battle.AI.Selectors.BaseSelector")
---@class SequenceSelector
local Sequence = class("SequenceSelector", base)
local BT = require("GameLogics.Battle.AI.BehaviourTree")

function Sequence:ctor()
    self.actions = nil
    self.running = false
    self.lastIndex = 0
end

-- 顺序执行
function Sequence:Execute(delta)
    for i = self.lastIndex, #self.actions do
        local result = self.actions[i]:Execute(delta)
        if result == BT.NodeState.Success then
            --continue next action
            self.running = false
            if i == #self.actions then
                return BT.NodeState.Success
            end
        elseif result == BT.NodeState.Fail then
            self.running = false
            return BT.NodeState.Fail
        else
            self.running = true
            self.lastIndex = i
            return BT.NodeState.Running
        end
    end
end

return Sequence
