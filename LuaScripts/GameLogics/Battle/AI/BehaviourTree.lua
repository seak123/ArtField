---@class BehaviourTree
local Tree = class("BehaviourTree")

Tree.NodeState = {
    Success = 0,
    Running = 1,
    Fail = 2
}

local exampleData = {
    root = {
        feature = "Selector",
        type = "Single",
        vo = {
            selectType = "Default"
        },
        actions = {
            {
                feature = "Action",
                type = "Wait",
                decorators = {
                    {
                        feature = "Decorator",
                        type = "SeekTarget",
                        vo = {
                            seekType = "NearestEnemy"
                        }
                    }
                },
                vo = {}
            },
            {
                feature = "Action",
                type = "Attack",
                decorators = {
                    {
                        feature = "Decorator",
                        type = "SeekTarget",
                        vo = {
                            seekType = "NearestEnemy"
                        }
                    }
                },
                vo = {}
            },
            {
                feature = "Action",
                type = "Move",
                decorators = {
                    {
                        feature = "Decorator",
                        type = "SeekTarget",
                        vo = {
                            seekType = "NearestEnemy"
                        }
                    }
                },
                vo = {}
            }
        }
    }
}

function Tree:ctor(master)
    self.master = master
    self.root = nil
    self:Init(exampleData.root)
end

function Tree:Init(treeData)
    self.root = self:ParaseData(treeData)
end

function Tree:ParaseData(data, parentNode)
    local nodePath = "GameLogics.Battle.AI." .. data.feature .. "s." .. data.type .. data.feature
    local newNode
    if data.feature == "Decorator" then
        newNode = require(nodePath).new(parentNode, data.vo)
    else
        newNode = require(nodePath).new(self, data.vo)
    end
    if data.actions ~= nil and #data.actions > 0 then
        newNode.actions = {}
        for i = 1, #data.actions do
            table.insert(newNode.actions, self:ParaseData(data.actions[i], newNode))
        end
    end
    if data.decorators ~= nil and #data.decorators > 0 then
        newNode.decorators = {}
        for i = 1, #data.decorators do
            table.insert(newNode.decorators, self:ParaseData(data.decorators[i], newNode))
        end
    end
    return newNode
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
    while #queue > 0 do
        local cur = queue[1]
        cur:CleanUp()
        if cur.actions ~= nil and #cur.actions > 0 then
            for i = 1, #cur.actions do
                table.insert(queue, cur.actions[i])
            end
        end
        table.remove(queue, 1)
    end
end

return Tree
