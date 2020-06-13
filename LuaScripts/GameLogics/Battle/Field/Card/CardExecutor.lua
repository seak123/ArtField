---@class CardExecutor
local CardExecutor = class("CardExecutor")
local BaseNode = require("GameLogics.Battle.Action.Nodes.BaseNode")
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
-- local function ExecuteNode(sess,spellCfg, rootVO, param)
--     local vo = require(BaseNode.NodePath[spellCfg.nodeType]).new(sess, spellCfg):Excute(param)
--     if rootVO == nil then
--         rootVO = vo
--     else
--         rootVO.childCount = rootVO.childCount + 1
--         table.insert(rootVO.childs, vo)
--     end

--     if rootVO.childs == nil then
--         rootVO.childs = {}
--         rootVO.childCount = 0
--     end

--     if spellCfg.childs ~= nil and #spellCfg.childs > 0 then
--         for i = 1, #spellCfg.childs do
--             ExecuteNode(spellCfg.childs[i], vo, param)
--         end
--     end

--     return rootVO
-- end

function CardExecutor:ExecuteCard(cardVO, param)
    local spellCfg = ConfigManager:GetSpellConfig(cardVO.id)
    -- for i = 1, #spellCfg do
    --     local performVO = ExecuteNode(self.sess,spellCfg[i],nil,param)
    --     EventManager:Emit("PerfomerPushNode", performVO)
    -- end

    return true
end

return CardExecutor
