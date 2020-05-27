--[[
    author:yaxinge
    time:2020-05-05 11:11:44
]]
local LuaBehaviour = require("GameCore.Base.Framework.LuaBehaviour")
---@class UIItemListView
local UIItemListView = class("UIItemListView", LuaBehaviour)
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

function UIItemListView:ctor(obj)
    self.super.ctor(self, obj, setting)
    self.vertical = false
    self.getFunc = nil
    self.items = {}

    self.itemPrefabPath = ""

    self.contentHeight = 1
    self.contentWidth = 1
    self.viewHeight = 1
    self.viewWidth = 1

    self.itemCount = 0
    self.itemSize = 0
end

function UIItemListView:Init(itemPath, itemSize)
    if self.getFunc == nil then
        return Debug.Warn("[UIItemListView] getFunc is nil")
    end

    self.itemSize = itemSize
    self.itemPrefabPath = itemPath

    self.contentHeight = self.Content:GetComponent(typeof(CS.UnityEngine.RectTransform)).sizeDelta.y
    self.contentWidth = self.Content:GetComponent(typeof(CS.UnityEngine.RectTransform)).sizeDelta.x

    self:RefreshView()
end

function UIItemListView:OnAwake()
end

function UIItemListView:OnStart()
end

function UIItemListView:RefreshView()
    self:ClearItems()
    if self.vertical then
        --TODO
    else
        local index = 1
        while self.getFunc(index) ~= nil do
            -- TODO improve
            local obj = CS.WindowsUtil.AddWindow(self.itemPrefabPath)
            obj.transform:SetParent(self.Content.transform)
            obj.transform.localPosition =
                CS.LuaCallCSharpUtil.CreateVector3((index - 0.5) * self.itemSize, -self.itemSize / 2, 0)
            table.insert(self.items, obj)
            local lb = BehaviourManager:GetBehaviour(obj:GetInstanceID())
            lb:SetData(self.getFunc(index))

            index = index + 1
        end
    end
end

function UIItemListView:ClearItems()
    for i = 1, #self.items do
        if self.items[i] ~= nil then
            CS.WindowsUtil.RemoveWindow(self.items[i])
        end
    end
    self.items = {}
end

return UIItemListView
