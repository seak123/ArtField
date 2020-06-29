---@class CardExecutor
local CardExecutor = class("CardExecutor")
local EventConst = require("GameCore.Constant.EventConst")

CardExecutor.State = {
    Hero = 1, -- 布阵英雄
    Normal = 2, -- 普通状态，手牌
    Equipment = 3 -- 选择装备
}

function CardExecutor:ctor(sess)
    ---@type BattleSession
    self.sess = sess
    if not SystemConst.logicMode then
        self:Init()
    end
end

function CardExecutor:Init()
    local UIConst = require("GameLogics.Constant.UIConst")
    local cardPanelObj = CS.WindowsUtil.AddWindow(UIConst.CardMainPanel, UIConst.Layer.MainLayer0)
    ---@type CardPanel
    self.cardPanelLb = BehaviourManager:GetBehaviour(cardPanelObj:GetInstanceID())
    self:Register()
end

function CardExecutor:Register()
    EventManager:On(EventConst.ON_CARD_CHANGE, self.RefreshView, self)
end

function CardExecutor:UnRegister()
end
--------------------------------  card view -----------------------
function CardExecutor:SwitchState(state)
    if state == CardExecutor.State.Hero then
        local data = {}
        for i = 1, #self.sess.field.heroCards[1] do
            table.insert(data, self.sess.field.heroCards[1][i])
        end
        for i = 1, #self.sess.field.heroCards[2] do
            table.insert(data, self.sess.field.heroCards[2][i])
        end
        self.cardPanelLb:SetData(data)
    elseif state == CardExecutor.State.Normal then
    end
end

function CardExecutor:RefreshView()
    self.cardPanelLb:RefreshScroll()
end
-------------------------------   card logic ------------------------------

function CardExecutor:ExecuteCard(camp, cardVO, param)
    local spellCfg = ConfigManager:GetCardSpellConfig(cardVO.id)
    local targetParams = {
        caster = {camp = camp},
        target = nil,
        point = {x = param.selectPos.x, z = param.selectPos.y}
    }
    self.sess.field.spellExecutor:ExecuteSpell(spellCfg, targetParams)
    return true
end

return CardExecutor
