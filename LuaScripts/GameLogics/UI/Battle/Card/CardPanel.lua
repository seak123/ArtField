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
        },
        {
            Name = "Button",
            Type = CS.UnityEngine.UI.Button,
            Handler = {
                onClick = "OnClickButton"
            }
        },
        {
            Name = "Button/Text",
            Alias = "ButtonTxt",
            Type = CS.UnityEngine.UI.Text
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
    self.ScrollView.getFunc = function(index)
        return self.data[index]
    end
    ---@type UIItemListView
    self.ScrollView:Init(UIConst.Card, 180)
end

function CardPanel:SetBtnText(text)
    self.ButtonTxt.text = text
end

function CardPanel:SetBtnCallback(func)
    if func ~= nil then
        self.btnCallback = func
        self.Button.gameObject:SetActive(true)
    else
        self.Button.gameObject:SetActive(false)
    end
end

function CardPanel:OnAwake()
end

function CardPanel:OnStart()
    -- get luabehaviour
    --self.ScrollView =
end

function CardPanel:RefreshScroll()
    self.ScrollView:RefreshView()
end

function CardPanel:OnClickButton()
    if self.btnCallback ~= nil then
        self.btnCallback()
    end
end

return CardPanel
