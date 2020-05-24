---@class CardExcutor
local CardExcutor = class("CardExcutor")
local ConfigManager = require("GameCore.Base.Config.ConfigManager")
local BaseNode = require("GameLogics.Battle.Action.Nodes.BaseNode")
local UIConst = require("GameLogics.Constant.UIConst")

CardExcutor.State = {
    Hero = 1, -- 布阵英雄
    Normal = 2, -- 普通状态，手牌
    Equipment = 3 -- 选择装备
}

function CardExcutor:ctor(sess)
    ---@type BattleSession
    self.sess = sess
    self:Init()
end

function CardExcutor:Init()
    local cardPanelObj = CS.WindowsUtil.AddWindow(UIConst.CardMainPanel, UIConst.Layer.MainLayer0)
    ---@type CardPanel
    self.cardPanelLb = BehaviourManager:GetBehaviour(cardPanelObj:GetInstanceID())
    self:Register()
end

function CardExcutor:Register()
end

function CardExcutor:UnRegister()
end

function CardExcutor:SwitchState(state)
    if state == CardExcutor.State.Hero then
        self.cardPanelLb:SetData(self.sess.field.heroCards)
    elseif state == CardExcutor.State.Normal then
    elseif state == CardExcutor.State.Equipment then
    end
end

function CardExcutor:ExecuteCard(cardVO, x, z)
    Debug.Warn("execute " .. cardVO.Id)
    
    local spellCfg = ConfigManager:GetSpellConfig(cardVO.Id)
    for i = 1, #spellCfg do
        require(BaseNode.NodePath[spellCfg[i].NodeType]).new(self.sess, spellCfg[i]):Excute(x, z)
    end
end

return CardExcutor
