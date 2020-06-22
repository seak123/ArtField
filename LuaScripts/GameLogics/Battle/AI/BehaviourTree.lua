---@class BehaviourTree
local Tree = class("BehaviourTree")

Tree.NodeState = {
    Success = 0,
    Running = 1,
    Fail = 2
}

function Tree:ctor(master)
    self.master = master
    self.root = nil
end

local example = {
    root = {
        featrue = "Selector",
        type = "Single",
        vo = {
            selectType = "Default",
        },
        actions = {
            {
                feature = "Action",
                type = "Attack",
                vo = {
                    
                }
            }
        }
    }
}

function Tree:Init(treeData)
end

function Tree:Execute(delta)
    local result = self.root:Execute(delta)
    if result == Tree.NodeState.Success or result == Tree.NodeState.Fail then
        --clean
        self:CleanUp()
    end
end

function Tree:CleanUp()
    local queue = {self.root}
    while #queue >0 do
        local cur = queue[1]
        cur:CleanUp()
        if cur.actions ~= nil and #cur.actions > 0 then
            for i = 1, #cur.actions do
                table.insert(queue,cur.actions[i])
            end
        end
        table.remove(queue,1)
    end
end

return Tree
