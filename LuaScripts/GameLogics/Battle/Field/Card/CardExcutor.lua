---@class CardExcutor
local CardExcutor = class("CardExcutor")
local ConfigManager = require("GameCore.Base.Config.ConfigManager")
local BaseNode = require("GameLogics.Battle.Action.Nodes.BaseNode")

function CardExcutor:ctor(sess)
    self.sess = sess
    self:Register()
end

function CardExcutor:Register()
    EventManager:On("ExcuteCard", self.ExecuteCard, self)
end

function CardExcutor:ExecuteCard(cuid, x, z)
    local cardVO = self.sess.field.cards[cuid]
    Debug.Warn("execute " .. cardVO.Id)
    local spellCfg = ConfigManager:GetSpellConfig(cardVO.Id)
    for i = 1, #spellCfg do
        require(BaseNode.NodePath[spellCfg[i].NodeType]).new(self.sess, spellCfg[i]):Excute(x, z)
    end
end

return CardExcutor
