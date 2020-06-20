---@class Creature
local Creature = class("Creature")
local Properties = require("GameLogics.Battle.Field.Unit.Components.Properties")
local Avatar = require("GameLogics.Battle.Field.Unit.Components.Avatar")
local Brain = require("GameLogics.Battle.Field.Unit.Components.ArtiBrain")
local MoveCtrl = require("GameLogics.Battle.Field.Unit.Components.MoveController")

function Creature:ctor(sess, unitVO)
    ---@type BattleSession
    self.sess = sess
    self.vo = unitVO
end

function Creature:Init()
    -- init pos
    self.moveCtrl = MoveCtrl.new(self)

    self.properties = Properties.new(self)
    self.avatar = Avatar.new(self)
    self.brain = Brain.new(self)
    
    -- attack storage [0,1] record the attack process
    self.attackStorage = 0
    self.lastAttackTime = 0
    self.atkTargetUid = 0
end

function Creature:Update(delta)
    self.brain:Update(delta)
    self.moveCtrl:Update(delta)
end

function Creature:DoAttack(delta,target)
    local interval = self.properties:GetProperty("attackTime")
    if self.sess.curTime < self.lastAttackTime + interval*(1-self.properties:GetProperty("attackAnim")) then
        -- interval isnt enough to make next attack
        return false
    end
    if self.attackStorage == 0 then
        -- start a new attack process
        self.atkTargetUid = target.uid
        self.avatar:SwitchAction(Avatar.ActionType.Attack)
    else
        if target.uid ~= self.atkTargetUid then
            -- switch to a new target
            self.atkTargetUid = target.uid
            self.attackStorage = 0
            self.avatar:SwitchAction(Avatar.ActionType.Attack)
        end
    end

    self.avatar:TurnToTarget(target)
    
    self.attackStorage = self.attackStorage + delta / interval
    if self.attackStorage >= self.properties:GetProperty("attackAnim") then
        -- make normal attack

        self.lastAttackTime = self.sess.curTime
    end
    if self.attackStorage >= 1 then
        -- end attack process
        self.attackStorage = 0
    end
    return true
end

return Creature
