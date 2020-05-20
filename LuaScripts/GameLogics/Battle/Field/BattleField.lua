--[[
    author:yaxinge
    time:2020-05-16 18:19:58
]]
---@class BattleField
local BattleField = class("BattleField")
local Creature = require("GameLogics.Battle.Field.Unit.Creature")
local EventConst = require("GameCore.Constant.EventConst")
local BaseNode = require("GameLogics.Battle.Action.Nodes.BaseNode")

---@param sess BattleSession
---@return BattleField
function BattleField:New(sess)
    return self.new(sess)
end

function BattleField:ctor(sess)
    self.sess = sess
    self.uid = 0 -- 单位uid
    self.cuid = 0 -- 卡片uid
    self.units = {}
    self.heros = {}
    self.cards = {}
    self.heroCards = {}
    self:RegisterEvent()
end

function BattleField:RegisterEvent(  )
    EventManager:On("ExcuteCard", self.ExecuteCard, self)
end

function BattleField:CreateUnit(unitVO)
    local unit = Creature:New(unitVO)
    self.uid = self.uid + 1
    unit.uid = self.uid

    self.units[unit.uid] = unit
    return self.uid
end

function BattleField:CreateHeroCards(heroIds)
    for i = 1, #heroIds do
        local vo = ConfigManager.GetCardConfig(heroIds[i]);
        self.cuid = self.cuid + 1
        vo.uid = self.cuid
        table.insert(self.heroCards, vo)
        self.cards[self.cuid] = vo
    end
end

function BattleField:ExecuteCard( cuid ,x,z)
    local cardVO = self.cards[cuid]
    Debug.Warn("execute "..cardVO.Id)
    local spellCfg = CardConfig.CardSpells[cardVO.Id]
    for i=1,#spellCfg do
        require( BaseNode.NodePath[spellCfg[i].NodeType]):New(self.sess,spellCfg[i]):Excute(x,z)
    end
end


return BattleField
