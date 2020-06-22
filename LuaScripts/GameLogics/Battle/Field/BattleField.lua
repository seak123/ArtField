--[[
    author:yaxinge
    time:2020-05-16 18:19:58
]]
---@class BattleField
local BattleField = class("BattleField")
local Creature = require("GameLogics.Battle.Field.Unit.Creature")
local EventConst = require("GameCore.Constant.EventConst")
local CardExecutor = require("GameLogics.Battle.Field.Card.CardExecutor")
local SpellExecutor = require("GameLogics.Battle.Field.Effect.SpellExecutor")
local FSM = require("GameLogics.Battle.Session.SessionFSM")

function BattleField:ctor(sess)
    ---@type BattleSession
    self.sess = sess
    self:Init()
end

function BattleField:Init()
    self.uid = 0 -- 单位uid
    self.cuid = 0 -- 卡片uid
    self.units = {
        {},
        {}
    }
    self.heroCards = {{}, {}}

    self.cardExecutor = CardExecutor.new(self.sess)
    self.spellExecutor = SpellExecutor.new(self.sess)

    self:Register()
end

function BattleField:Update(delta)
    self.spellExecutor:Update(delta)
end

function BattleField:Register()
    EventManager:On("ExecuteCard", self.PlayCard, self)
end

------------------------------------- event functions ------------------------------

------------------------------------- unit functions ------------------------------
function BattleField:CreateUnit(unitVO, camp)
    local camp = camp ~= nil and camp or 1
    self.uid = self.uid + 1
    unitVO.camp = camp
    unitVO.uid = self.uid
    local unit = Creature.new(self.sess, unitVO)

    self.units[unit.camp][unit.uid] = unit
    return self.uid
end

function BattleField:FindUnit(uid)
    return self.units[1][uid] or self.units[2][uid]
end

function BattleField:FindUnitIf(func)
    for uid, unit in pairs(self.units[1]) do
        if func(unit) then
            return unit
        end
    end
    for uid, unit in pairs(self.units[2]) do
        if func(unit) then
            return unit
        end
    end
    return nil
end

function BattleField:UnitForeach(func)
    for uid, unit in pairs(self.units[1]) do
        func(unit)
    end
    for uid, unit in pairs(self.units[2]) do
        func(unit)
    end
end

------------------------------------- card functions ------------------------------

function BattleField:FindHeroCards(cuid)
    for i = 1, #self.heroCards[1] do
        if self.heroCards[1][i].uid == cuid then
            return self.heroCards[1][i]
        end
    end
    for i = 1, #self.heroCards[2] do
        if self.heroCards[2][i].uid == cuid then
            return self.heroCards[2][i]
        end
    end
    return nil
end

function BattleField:RemoveHeroCard(cuid)
    for i = 1, #self.heroCards[1] do
        if self.heroCards[1][i].uid == cuid then
            table.remove(self.heroCards[1], i)
        end
    end
    for i = 1, #self.heroCards[2] do
        if self.heroCards[2][i].uid == cuid then
            table.remove(self.heroCards[2], i)
        end
    end
    EventManager:Emit(EventConst.ON_CARD_CHANGE)
end

------------------------------------- game logic ------------------------------

function BattleField:InjectData(heroIds)
    self.heroCards = {{}, {}}
    for i = 1, #heroIds[1] do
        local vo = ConfigManager:GetCardConfig(heroIds[1][i])
        self.cuid = self.cuid + 1
        vo.uid = self.cuid
        vo.camp = 1
        table.insert(self.heroCards[1], vo)
    end
    for i = 1, #heroIds[2] do
        local vo = ConfigManager:GetCardConfig(heroIds[2][i])
        self.cuid = self.cuid + 1
        vo.uid = self.cuid
        vo.camp = 2
        table.insert(self.heroCards[2], vo)
    end
end

-- 打出开牌 cuid
function BattleField:PlayCard(camp, cuid, param)
    local cardVO =
        self.sess.state == FSM.SessionType.EmbattleHero and self:FindHeroCards(cuid) or self:FindHeroCards(cuid)

    if cardVO == nil then
        return Debug.Error("无法施放卡牌,原因:无法找到该卡牌")
    end

    self.cardExecutor:ExecuteCard(camp, cardVO, param)
end

return BattleField
