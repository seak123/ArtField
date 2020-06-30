local base = require("GameLogics.Battle.AI.Actions.BaseAction")
---@class AttackAction
local Atk = class("AttackAction",base)
local BT = require("GameLogics.Battle.AI.BehaviourTree")

function Atk:ctor(tree,vo)
    self.tree = tree
    self.decorators = nil
    self.targetPos = nil
    self.running = false
end

function Atk:CleanUp()
    self.running = false
    self.targetPos = nil
end

function Atk:Execute(delta)
    if self.running == false then
        -- On enter, execute decorators firstly
        if self:ExDecorator() == false then
            return BT.NodeState.Fail
        end
    else 
        if self:ExInterpDecorator() == true then
            return BT.NodeState.Fail
        end
    end

    if self.targetPos == nil then
        return BT.NodeState.Fail
    else
        local target = self.tree.master.sess.map:GetMapGridInfo(self.targetPos.x,self.targetPos.z).unit
        if target == nil then
            -- cannot find a unit standing on target point
            return BT.NodeState.Fail
        end
        if self.tree.master:DoAttack(delta,target) then
            self.running = true
            return BT.NodeState.Running
        else
            return BT.NodeState.Fail
        end
    end
end

return Atk