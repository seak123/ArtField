---@class BaseAction
local BaseAction = class("BaseAction")
local Tree = require("GameLogics.Battle.AI.BehaviourTree")

function BaseAction:ctor()
end

function BaseAction:Execute()
    return Tree.NodeState.Fail
end

return BaseAction