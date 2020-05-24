--[[
    author:yaxinge
    time:2020-05-16 18:19:58
]]
---@class BattleField
local BattleField = class("BattleField")
local Creature = require("GameLogics.Battle.Field.Unit.Creature")
local EventConst = require("GameCore.Constant.EventConst")
local BaseNode = require("GameLogics.Battle.Action.Nodes.BaseNode")
local CardExcutor = require("GameLogics.Battle.Field.Card.CardExcutor")

function BattleField:ctor(sess)
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
    self.cardExcutor = CardExcutor.new(self.sess)

    self:Register()
end

function BattleField:Register()
    EventManager:On("ExcuteCard", self.PlayCard, self)
end

------------------------------------- unit functions ------------------------------
function BattleField:CreateUnit(unitVO)
    local unit = Creature.new(unitVO)
    self.uid = self.uid + 1
    unit.uid = self.uid

    self.units[unit.uid] = unit
    return self.uid
end

------------------------------------- card functions ------------------------------

function BattleField:CreateHeroCards(heroIds)
    for i = 1, #heroIds do
        local vo = ConfigManager:GetCardConfig(heroIds[i])
        self.cuid = self.cuid + 1
        vo.uid = self.cuid
        table.insert(self.heroCards, vo)
        self.cards[self.cuid] = vo
    end
end

function BattleField:FindHandCards(cuid)
    for i = 1, #self.handCards do
        if self.handCards[i].uid == cuid then
            return self.handCards[i]
        end
    end
    return nil
end

function BattleField:FindHeroCards(cuid)
    for i = 1, #self.heroCards do
        if self.heroCards[i].uid == cuid then
            return self.heroCards[i]
        end
    end
    return nil
end

function BattleField:PlayCard(cuid, x, z)
    local cardVO = self:FindHandCards(cuid)
    if cardVO == nil then
        -- check heroCards
        cardVO = self:FindHeroCards(cuid)
        if cardVO == nil then
            return Debug.Error("无法施放卡牌,原因:无法找到该卡牌")
        end
    end
    self.cardExcutor:ExecuteCard(cardVO, x, z)
end

return BattleField
