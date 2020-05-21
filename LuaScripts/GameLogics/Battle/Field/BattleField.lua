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
    self.uid = 0 -- 单位uid
    self.cuid = 0 -- 卡片uid
    self.units = {}
    self.heros = {}
    ---@type CardVO[]
    self.cards = {}
    self.heroCards = {}
    self.cardExcutor = CardExcutor.new(sess)
end



function BattleField:CreateUnit(unitVO)
    local unit = Creature.new(unitVO)
    self.uid = self.uid + 1
    unit.uid = self.uid

    self.units[unit.uid] = unit
    return self.uid
end

function BattleField:CreateHeroCards(heroIds)
    for i = 1, #heroIds do
        local vo = ConfigManager:GetCardConfig(heroIds[i]);
        self.cuid = self.cuid + 1
        vo.uid = self.cuid
        table.insert(self.heroCards, vo)
        self.cards[self.cuid] = vo
    end
end

return BattleField
