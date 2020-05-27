--[[
    author:yaxinge
    time:2020-05-16 18:19:58
]]
---@class BattleField
local BattleField = class("BattleField")
local Creature = require("GameLogics.Battle.Field.Unit.Creature")
local EventConst = require("GameCore.Constant.EventConst")
local BaseNode = require("GameLogics.Battle.Action.Nodes.BaseNode")
local CardExecutor = require("GameLogics.Battle.Field.Card.CardExecutor")
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
    ---@type CardVO[]
    self.cards = {}
    self.handCards = {}
    self.heroCards = {}
    self.heroGrave = {}
    self.cardExcutor = CardExecutor.new(self.sess)

    self:Register()
end

function BattleField:Register()
    EventManager:On("ExcuteCard", self.PlayCard, self)
    EventManager:On(EventConst.ON_ENTER_BEGIN_STATE, self.OnEnterBeginState, self)
end

------------------------------------- event functions ------------------------------
function BattleField:OnEnterBeginState()
    self.heroCards = {}
    for i = 1, #self.heroGrave do
        self.heroGrave[i].resetRound = self.heroGrave[i].resetRound - 1
        if self.heroGrave[i].resetRound == 0 then
            local vo = ConfigManager:GetCardConfig(self.heroGrave[i].id)
            self.cuid = self.cuid + 1
            vo.uid = self.cuid
            table.insert(self.heroCards, vo)
        end
    end
end

------------------------------------- unit functions ------------------------------
function BattleField:CreateUnit(unitVO)
    local unit = Creature.new(self.sess,unitVO)
    self.uid = self.uid + 1
    unit.uid = self.uid

    self.units[unit.uid] = unit
    return self.uid
end

------------------------------------- card functions ------------------------------

function BattleField:RemoveHandCard(cuid)
end

function BattleField:FindHandCards(cuid)
    for i = 1, #self.handCards do
        if self.handCards[i].uid == cuid then
            return self.handCards[i]
        end
    end
    return nil
end

function BattleField:RemoveHandCard(cuid)
    for i = 1, #self.heroCards do
        if self.handCards[i].uid == cuid then
            table.remove(self.handCards, i)
        end
    end
    EventManager.Emit(EventConst.ON_CARD_CHANGE)
end

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
    for i = 1, #heroIds do
        table.insert(self.heroGrave, {resetRound = i, id = heroIds[i]})
    end
end

-- 打出开牌 cuid
function BattleField:PlayCard(cuid, param)
    local cardVO =
        self.sess.state == FSM.SessionType.EmbattleHero and self:FindHeroCards(cuid) or self:FindHeroCards(cuid)

    if cardVO == nil then
        return Debug.Error("无法施放卡牌,原因:无法找到该卡牌")
    end

    if self.cardExcutor:ExecuteCard(cardVO, param) then
        -- play card completed
        if self.sess.state == FSM.SessionType.EmbattleHero then
            self:RemoveHeroCard(cuid)
        else
            self:RemoveHandCard(cuid)
        end
    end
end

return BattleField
