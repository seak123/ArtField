---@class BehaviourTree
local Tree = class("BehaviourTree")

Tree.NodeState = {
    Success = 0,
    Running = 1,
    Fail = 2
}

function Tree:ctor()
    self.root = nil
end

function Tree:Execute(delta)
    if self.root ~= nil then
        self.root:Execute(delta)
    end
end

function Tree:CleanUp()
end

return Tree
