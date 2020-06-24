---@class Creature
local Creature = class("Creature")
local Event = require("GameCore.Base.Event.Event")
local Properties = require("GameLogics.Battle.Field.Unit.Components.Properties")
local Avatar = require("GameLogics.Battle.Field.Unit.Components.Avatar")
local Brain = require("GameLogics.Battle.Field.Unit.Components.ArtiBrain")
local MoveCtrl = require("GameLogics.Battle.Field.Unit.Components.MoveController")
local NormalAtkCfg = require("GameLogics.Config.Spell.Common.NormalAtkCfg")

function Creature:ctor(sess, unitVO)
    ---@type BattleSession
    self.sess = sess
    self.vo = unitVO
    self.camp = self.vo.camp
    self.uid = self.vo.uid
    self.name = self.camp .. "_" .. self.vo.name .. "_" .. self.uid
    self.eventMap = {}
    self:Init()
end

function Creature:Init()
    -- init pos
    self.moveCtrl = MoveCtrl.new(self)

    self.properties = Properties.new(self)
    self.avatar = Avatar.new(self)
    self.brain = Brain.new(self)

    -- base info
    self.hp = self.properties:GetProperty("hp")

    -- attack storage [0,1] record the attack process
    self.attackStorage = 0
    self.lastAttackTime = 0
    self.atkTargetUid = 0

    -- bind events
    self:RegisterEvent("OnHpChange", Handle:new(self.OnHpChange, self))
end

function Creature:Update(delta)
    self.brain:Update(delta)
    self.moveCtrl:Update(delta)
end

function Creature:GetPos()
    --Debug.Log("get pos",tostring(self.moveCtrl.position.x),tostring(self.moveCtrl.position.z))
    return self.moveCtrl.position
end

------------------- base function -----------------------

function Creature:RegisterEvent(name, handler)
    if self.eventMap[name] == nil then
        self.eventMap[name] = {}
        self.eventMap[name] = Event.new(name)
    end
    self.eventMap[name]:Bind(handler)
end

function Creature:UnRegisterEvent(name, handler)
    self.eventMap[name]:UnBind(handler)
end

function Creature:Invoke(name)
    if self.eventMap[name] then
        self.eventMap[name]:Fire()
    end
end

function Creature:Damage(value, source)
    self:Invoke("OnDamage")
    self.hp = math.max(0, self.hp - value)
    self:Invoke("OnHpChange")
    if self.hp == 0 then
        self:Die()
    end
end

function Creature:Die()
    Debug.Log(self.name .. " Die")
    self.avatar:SwitchAction(Avatar.ActionType.Die)
    self.sess.field:RemoveUnit(self)
    self.sess.map:TryRemoveUnit(self)
end

------------------- event -------------------------------
function Creature:OnHpChange()
    -- TODO notify lifeslider change
    if not SystemConst.logicMode then
        local unitVO = self.vo

        unitVO.maxHp = self.properties:GetProperty("hp")
        unitVO.hp = self.hp

        CS.MapManager.Instance:UpdateUnitState(self.uid,unitVO)
    end
end

------------------- logic function -----------------------

function Creature:DoAttack(delta, target)
    local interval = self.properties:GetProperty("attackTime")
    if self.sess.curTime < self.lastAttackTime + interval * (1 - self.properties:GetProperty("attackAnim")) then
        -- interval isnt enough to make next attack
        self.attackStorage = 0
        return false
    end
    if self.sess.map:GetRangeDist(self:GetPos(), target:GetPos()) > self.properties:GetProperty("attackRange") then
        -- this dist between self and target is too long
        self.attackStorage = 0
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
        self.sess.field.spellExecutor:ExecuteSpell(
            NormalAtkCfg,
            {
                caster = self,
                target = target,
                point = {x = 0, z = 0}
            }
        )
        self.lastAttackTime = self.sess.curTime
    end
    if self.attackStorage >= 1 then
        -- end attack process
        self.attackStorage = 0
    end
    return true
end

return Creature
