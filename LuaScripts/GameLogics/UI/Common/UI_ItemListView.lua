--[[
    author:yaxinge
    time:2020-05-05 11:11:44
]]
local LuaBehaviour = require("GameCore.Base.Framework.LuaBehaviour")
local UI_ItemListView = class("UI_ItemListView", LuaBehaviour)
local EventConst = require("GameCore.Constant.EventConst")

local setting = {
    Elements = {
        {
            Name = ".",
            Alias = "ScrollView",
            Type = CS.UnityEngine.UI.ScrollRect
        },
        {
            Name = ".",
            Alias = "Root"
        },
        {
            Name = "Viewport/Content",
            Alias = "Content"
        }
    }
}

function UI_ItemListView:ctor(obj)
    self.super.ctor(self, obj, setting)
    self.getFunc = nil
end

function UI_ItemListView:Init(itemPath, itemSize)
    self.ViewSize = self.ScrollView.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform)).sizeDelta.y
    --self.ItemCount = math.round(self.ViewSize/itemSize)
    --CS.WindowsUtil.AddWindow("MainUI",CS.UILayer.MainLayer_0);

    --temp
    local index = 1
    while self.getFunc(index) ~= nil do
        local obj = CS.WindowsUtil.AddWindow(itemPath)
        obj.transform:SetParent(self.Content.transform)
        obj.transform.localPosition = CS.LuaCallCSharpUtil.CreateVector3(30 + index * itemSize, -self.ViewSize / 2, 0)
        local lb = __BehaviourManager:GetBehaviour(obj:GetInstanceID())
        lb:SetData(self.getFunc(index))

        index = index + 1
    end
end

function UI_ItemListView:OnAwake()
end

function UI_ItemListView:OnStart()
end

return UI_ItemListView
