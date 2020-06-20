---@class BaseAction
local BaseAction = class("BaseAction")
local BT = require("GameLogics.Battle.AI.BehaviourTree")

function BaseAction:ctor()
    self.decorators = nil
end

function BaseAction:ExDecorator()
    if self.decorators ~= nil then
        for i = 1, #self.decorators do
            if self.decorators[i]:Execute() == BT.NodeState.Fail then
                return BT.NodeState.Fail
            end
        end
    end
    return BT.NodeState.Success
end

function BaseAction:Execute()
    return BT.NodeState.Fail
end

return BaseAction