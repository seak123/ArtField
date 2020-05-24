
local LuaBehaviour = require("GameCore.Base.Framework.LuaBehaviour")
---@class CardPanel
local CardPanel = class("EmbattlePanel", LuaBehaviour)
local UIConst = require("GameLogics.Constant.UIConst")
local Event = require("GameCore.Base.Event.Event")

local setting = {
    Elements = {
        {
            Name = "ScrollView",
            Script = "GameLogics.UI.Common.UIItemListView"
        }
    }
}
---@type UIItemListView
CardPanel.ScrollView = nil

function CardPanel:ctor(obj)
    self.super.ctor(self, obj, setting)
end
---@param data CardVO[] 设置卡牌数据 用来初始化手牌界面
function CardPanel:SetData(data)
    self.data = data
    self:RefreshScroll()
end

function CardPanel:OnAwake()
end

function CardPanel:OnStart()
    -- get luabehaviour
    --self.ScrollView = 
end

function CardPanel:RefreshScroll()
    self.ScrollView.getFunc = function ( index )
        return self.data[index]
    end
    ---@type UIItemListView
    self.ScrollView:Init(UIConst.Card,180)
end

return CardPanel
