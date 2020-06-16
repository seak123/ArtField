---@class BehaviourTree
local Tree = class("BehaviourTree")

Tree.NodeState = {
    Finish = 0,
    Running = 1,
    Fail = 2,
}


function Tree:ctor()
    self.root = nil
end

function Tree:Execute()
end

return Tree