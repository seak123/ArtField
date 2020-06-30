local base = require("GameLogics.Battle.AI.Actions.BaseAction")
---@class WaitAction
local Wait = class("WaitAction", base)
local BT = require("GameLogics.Battle.AI.BehaviourTree")
local FSM = require("GameLogics.Battle.Session.SessionFSM")

Wait.WaitType = {
    Time = "Time",
    Enemy = "Enemy"
}

function Wait:ctor(tree, vo)
    self.tree = tree
    self.decorators = nil
    self.targetPos = nil
    self.running = false
    self.waitType = vo.waitType
    self.timing = 0
    self.delay = vo.delay
end

function Wait:CleanUp()
    self.running = false
    self.targetPos = nil
end

function Wait:Execute(delta)
    if self.running == false then
        -- On enter, execute decorators firstly
        if self:ExDecorator() == false then
            return BT.NodeState.Fail
        end
        self.timing = 0
    end
    if self.waitType == "Enemy" then
        if self.targetPos == nil then
            return BT.NodeState.Fail
        else
            ---@type Creature
            local target = self.tree.master.sess.map:GetMapGridInfo(self.targetPos.x, self.targetPos.z).unit
            if target == nil then
                -- cannot find a unit standing on target point
                return BT.NodeState.Fail
            end
            local targetPos = target:GetNextPos()
            local pos = self.tree.master:GetPos()
            local range = self.tree.master.sess.map:GetRangeDist(targetPos, pos)
            if range <= self.tree.master.properties:GetProperty("attackRange") then
                self.tree.master.avatar:TurnToPos(self.tree.master.sess.map:GetMapGridCenter(targetPos.x, targetPos.z))
                return BT.NodeState.Success
            end
            return BT.NodeState.Fail
        end
    elseif self.waitType == "Time" then
        self.timing = self.timing + delta
        if self.timing < self.delay then
            self.running = true
            return BT.NodeState.Running
        else
            return BT.NodeState.Success
        end
    end
end

return Wait
