---@class Creature
local Creature = class("Creature")
local Event = require("GameCore.Base.Event.Event")
local EventConst = require("GameCore.Constant.EventConst")
local Properties = require("GameLogics.Battle.Field.Unit.Components.Properties")
local Avatar = require("GameLogics.Battle.Field.Unit.Components.Avatar")
local Brain = require("GameLogics.Battle.Field.Unit.Components.ArtiBrain")
local MoveCtrl = require("GameLogics.Battle.Field.Unit.Components.MoveController")
local Condition = require("GameLogics.Battle.Field.Unit.Components.ConditionController")
local BuffMng = require("GameLogics.Battle.Field.Unit.Components.BuffManager")
local NormalAtkCfg = require("GameLogics.Config.Spell.Common.NormalAtkCfg")
local NoramlRangeAtkCfg = require("GameLogics.Config.Spell.Common.NormalRangeAtkCfg")

function Creature:ctor(sess, unitVO)
    ---@type BattleSession
    self.sess = sess
    self.vo = unitVO
    self.camp = self.vo.camp
    self.uid = self.vo.uid
    self.name = self.camp .. "*" .. self.vo.name .. "_" .. self.uid
    self.eventMap = {}
    self:Init()
end

function Creature:Init()
    -- init pos
    self.moveCtrl = MoveCtrl.new(self)

    self.properties = Properties.new(self)
    self.avatar = Avatar.new(self)
    self.brain = Brain.new(self)
    self.condition = Condition.new(self)
    self.buffMng = BuffMng.new(self)

    -- base info
    self.hp = self.properties:GetProperty("hp")
    self.ap = 0
    self.alive = true

    -- attack storage [0,1] record the attack process
    self.attackStorage = 0
    self.lastAttackTime = 0
    self.atkTargetUid = 0

    -- register event
    EventManager:AddListener(EventConst.ON_ENTER_ACTION, Handle:new(self.OnEnterAction, self))
    -- bind object events
    self:RegisterEvent("OnHpChange", Handle:new(self.OnHpChange, self))
end

function Creature:Update(delta)
    self.brain:Update(delta)
    self.moveCtrl:Update(delta)
    self.buffMng:Update(delta)
end

function Creature:GetPos()
    --Debug.Log("get pos",tostring(self.moveCtrl.position.x),tostring(self.moveCtrl.position.z))
    return self.moveCtrl.position
end

-- the next pos after moving
function Creature:GetNextPos()
    local task = self.sess.map:GetMoveTask(self.uid)
    if task then
        return task.goal
    end
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
    -- ap
    self.ap = self.ap + value
    self.ap = math.min(self.ap, self.properties:GetProperty("rage"))

    self:Invoke("OnHpChange")
    if self.hp == 0 and self.alive == true then
        self:Die()
    end
end

function Creature:Die()
    Debug.Log(self.name .. " Die")
    self.avatar:SwitchAction(Avatar.ActionType.Die)
    self.alive = false
    self.sess.field:RemoveUnit(self)
    self.sess.map:TryRemoveUnit(self)
end

function Creature:CleanUp()
    self.buffMng:CleanUp()
end

------------------- event -------------------------------
function Creature:OnHpChange()
    -- TODO notify lifeslider change
    if not SystemConst.logicMode then
        local unitVO = self.vo

        unitVO.maxHp = self.properties:GetProperty("hp")
        unitVO.hp = self.hp
        unitVO.ap = self.ap

        CS.MapManager.Instance:UpdateUnitState(self.uid, unitVO)
    end
end

function Creature:OnEnterAction()
    -- init passive spell
    if self.vo.passiveSp ~= nil and #self.vo.passiveSp > 0 then
        for i = 1, #self.vo.passiveSp do
            local spell = require(ConfigManager:GetSpellConfig(self.vo.passiveSp[i]).path)
            self.sess.field.spellExecutor:ExecuteSpell(
                spell,
                {
                    caster = self,
                    target = nil,
                    point = {x = 0, z = 0}
                }
            )
        end
    end
end

------------------- logic function -----------------------

function Creature:DoAttack(delta, target)
    local interval = self.properties:GetProperty("attackTime")
    if not target.alive then
        self.attackStorage = 0
        return false
    end
    if self.sess.map:GetRangeDist(self:GetPos(), target:GetPos()) > self.properties:GetProperty("attackRange") then
        -- this dist between self and target is too long
        self.attackStorage = 0
        return false
    end
    if self.sess.curTime < self.lastAttackTime + interval * (1 - self.properties:GetProperty("attackAnim")) then
        -- interval isnt enough to make next attack
        self.attackStorage = 0
        return true
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
        Debug.Log(self.name .. " make a normal attack")
        local spell = self.vo.isRange == 0 and NormalAtkCfg or NoramlRangeAtkCfg
        spell.projectileId = self.vo.projectileId
        spell.projectileSpeed = self.vo.projectileSpeed
        spell.projectileASpeed = self.vo.projectileASpeed
        self.sess.field.spellExecutor:ExecuteSpell(
            spell,
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
