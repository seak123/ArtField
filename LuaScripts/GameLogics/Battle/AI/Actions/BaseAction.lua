---@class BaseAction
local BaseAction = class("BaseAction")
local BT = require("GameLogics.Battle.AI.BehaviourTree")

function BaseAction:ctor()
    self.decorators = nil
end

function BaseAction:ExDecorator()
    if self.decorators ~= nil then
        for i = 1, #self.decorators do
            if self.decorators[i]:Execute() == false then
                return false
            end
        end
    end
    return true
end

function BaseAction:ExInterpDecorator()
    if self.interpDecorators ~= nil then
        for i = 1, #self.interpDecorators do
            if self.interpDecorators[i]:Execute() == true then
                return true
            end
        end
    end
    return false
end

function BaseAction:Execute()
    return BT.NodeState.Fail
end

return BaseAction