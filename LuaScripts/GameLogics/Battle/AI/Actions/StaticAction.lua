local base = require("GameLogics.Battle.AI.Actions.BaseAction")
---@class StaticAction
local Move = class("StaticAction", base)
local BT = require("GameLogics.Battle.AI.BehaviourTree")
local FSM = require("GameLogics.Battle.Session.SessionFSM")

function Move:ctor(tree,vo)
    self.tree = tree
    self.decorators = nil
    self.targetPos = nil
    self.running = false
    self.delay = vo.delay and vo.delay or 0
    self.timing = 0
end

function Move:CleanUp()
    self.running = false
    self.targetPos = nil
end

function Move:Execute(delta)
    if self.tree.master.sess.state == FSM.SessionType.Action then
        self.timing = self.timing + delta
        if self.timing < self.delay then
            return BT.NodeState.Running
        end
        return BT.NodeState.Fail
    else
        -- find nearst enemy here
        self:ExDecorator()
        local viewPos
        if self.targetPos ~= nil then
            viewPos = self.tree.master.sess.map:GetMapGridCenter(self.targetPos.x,self.targetPos.z)
        else
            viewPos =  self.tree.master.sess.map:GetMapViewCenter()
        end
        self.tree.master.avatar:TurnToPos(viewPos)
        self.running = true
        return BT.NodeState.Running
    end
    return BT.NodeState.Fail
end

return Move
