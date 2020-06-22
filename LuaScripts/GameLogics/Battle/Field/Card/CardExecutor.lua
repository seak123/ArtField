---@class CardExecutor
local CardExecutor = class("CardExecutor")
local EventConst = require("GameCore.Constant.EventConst")
local UIConst = require("GameLogics.Constant.UIConst")

CardExecutor.State = {
    Hero = 1, -- 布阵英雄
    Normal = 2, -- 普通状态，手牌
    Equipment = 3 -- 选择装备
}

function CardExecutor:ctor(sess)
    ---@type BattleSession
    self.sess = sess
    self:Init()
end

function CardExecutor:Init()
    local cardPanelObj = CS.WindowsUtil.AddWindow(UIConst.CardMainPanel, UIConst.Layer.MainLayer0)
    ---@type CardPanel
    self.cardPanelLb = BehaviourManager:GetBehaviour(cardPanelObj:GetInstanceID())
    self:Register()
end

function CardExecutor:Register()
    EventManager:On(EventConst.ON_CARD_CHANGE,self.RefreshView,self)
end

function CardExecutor:UnRegister()
end
--------------------------------  card view -----------------------
function CardExecutor:SwitchState(state)
    if state == CardExecutor.State.Hero then
        self.cardPanelLb:SetData(self.sess.field.heroCards)
    elseif state == CardExecutor.State.Normal then
    end
end

function CardExecutor:RefreshView()
    self.cardPanelLb:RefreshScroll()
end
-------------------------------   card logic ------------------------------ 

function CardExecutor:ExecuteCard(cardVO, param)
    local spellCfg = ConfigManager:GetSpellConfig(cardVO.id)
    local targetParams = {
        caster = {camp = 1},
        target = nil,
        point = {x=param.selectPos.x,y=param.selectPos.y}
    }
    self.sess.field.spellExecutor:ExecuteSpell(spellCfg,targetParams)
    return true
end

return CardExecutor
