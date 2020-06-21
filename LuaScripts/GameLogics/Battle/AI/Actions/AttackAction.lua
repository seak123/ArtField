local base = require("GameLogics.Battle.AI.Actions.BaseAction")
---@class AttackAction
local Atk = class("AttackAction",base)
local BT = require("GameLogics.Battle.AI.BehaviourTree")

function Atk:ctor(tree)
    self.tree = tree
    self.decorators = nil
    self.targetUid = 0
    self.running = false
end

function Atk:CleanUp()
    self.running = false
    self.targetUid = 0
end

function Atk:Execute(delta)
    if self.running == false then
        -- On enter, execute decorators firstly
        if self:ExDecorator() == BT.NodeState.Fail then
            return BT.NodeState.Fail
        end
    end

    if self.targetUid == 0 then
        -- select default enemy
    end
end

return Atk