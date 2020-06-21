local base = require("GameLogics.Battle.AI.Actions.BaseAction")
---@class MoveAction
local Move = class("MoveAction", base)
local BT = require("GameLogics.Battle.AI.BehaviourTree")

function Move:ctor(tree)
    self.tree = tree
    self.decorators = nil
    self.targetUid = 0
    self.running = false
end

function Move:CleanUp()
    self.running = false
    self.targetUid = 0
end

function Move:Execute(delta)
    if self.running == false then
        -- On enter, execute decorators firstly
        if self:ExDecorator() == BT.NodeState.Fail then
            return BT.NodeState.Fail
        end
    else
        if self.tree.master.moveCtrl.moving == true then
            return BT.NodeState.Running
        else
            return BT.NodeState.Success
        end
    end

    if self.targetPos ~= nil then
        if self.tree.master.moveCtrl:MoveToPos(self.targetPos) then
            self.running = true
            return BT.NodeState.Running
        end
    end

    return BT.NodeState.Fail
end

return Move
