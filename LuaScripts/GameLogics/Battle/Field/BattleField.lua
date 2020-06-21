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
    self.units = {}
    self.heros = {}
    self.heroCards = {}

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
function BattleField:CreateUnit(unitVO)
    local unit = Creature.new(self.sess, unitVO)
    self.uid = self.uid + 1
    unit.uid = self.uid

    self.units[unit.uid] = unit
    return self.uid
end

function BattleField:FindUnit(uid)
    return self.units[uid]
end

------------------------------------- card functions ------------------------------

function BattleField:FindHeroCards(cuid)
    for i = 1, #self.heroCards do
        if self.heroCards[i].uid == cuid then
            return self.heroCards[i]
        end
    end
    return nil
end

function BattleField:RemoveHeroCard(cuid)
    for i = 1, #self.heroCards do
        if self.heroCards[i].uid == cuid then
            table.remove(self.heroCards, i)
        end
    end
    EventManager:Emit(EventConst.ON_CARD_CHANGE)
end

------------------------------------- game logic ------------------------------

function BattleField:InjectData(heroIds)
    self.heroCards = {}
    for i = 1, #heroIds do
        local vo = ConfigManager:GetCardConfig(heroIds[i])
        self.cuid = self.cuid + 1
        vo.uid = self.cuid
        table.insert(self.heroCards, vo)
    end
end

-- 打出开牌 cuid
function BattleField:PlayCard(cuid, param)
    local cardVO =
        self.sess.state == FSM.SessionType.EmbattleHero and self:FindHeroCards(cuid) or self:FindHeroCards(cuid)

    if cardVO == nil then
        return Debug.Error("无法施放卡牌,原因:无法找到该卡牌")
    end

    self.cardExecutor:ExecuteCard(cardVO, param)
end

return BattleField
