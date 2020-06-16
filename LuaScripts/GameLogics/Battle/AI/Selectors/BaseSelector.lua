---@class BaseSelector
local BaseSelector = class("BaseSelector")
local Tree = require("GameLogics.Battle.AI.BehaviourTree")

function BaseSelector:ctor()
end

function BaseSelector:Execute()
    return Tree.NodeState.Fail
end

return BaseSelector