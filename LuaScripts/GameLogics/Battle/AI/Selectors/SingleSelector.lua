local base = require("GameLogics.Battle.AI.Selectors.BaseSelector")
---@class SingleSelector
local Single = class("SingleSelector", base)
local BT = require("GameLogics.Battle.AI.BehaviourTree")

Single.SelectType = {
    Default = "Default", --默认优先级递减
    Random = "Random" --随机选择
}

Single.ExecuteMap = {
    [Single.SelectType.Default] = "DefaultExecutor",
    [Single.SelectType.Random] = "RandomExecutor"
}

function Single:ctor(tree,vo)
    self.tree = tree
    self.actions = nil
    self.running = false
    self.lastIndex = 0
    self.selectType = vo.selectType
end

-- 选择其一执行
function Single:Execute(delta)
    return Single[Single.ExecuteMap[self.selectType]](self, delta)
end

function Single:CleanUp()
    self.running = false
    self.lastIndex = 0
end

-- 按优先级选择其一可执行(非直接返回fail)action
function Single.DefaultExecutor(self, delta)
    if self.running then
        return self.actions[self.lastIndex]:Execute(delta)
    end
    for i = 1, #self.actions do
        local result = self.actions[i]:Execute(delta)
        if result == BT.NodeState.Success then
            return BT.NodeState.Success
        elseif result == BT.NodeState.Fail then
            -- continue to next action
        else
            self.running = true
            self.lastIndex = i
            return BT.NodeState.Running
        end
    end
    -- none action can exexute
    return BT.NodeState.Fail
end

function Single.RandomExecutor(self, delta)
end

return Single
