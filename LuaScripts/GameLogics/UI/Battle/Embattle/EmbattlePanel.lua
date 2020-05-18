--[[
    author:yaxinge
    time:2020-05-02 23:47:30
]]
local LuaBehaviour = require("GameCore.Base.Framework.LuaBehaviour")
local EmbattlePanel = class("EmbattlePanel", LuaBehaviour)
local UIConst = require("GameLogics.Constant.UIConst")
local Event = require("GameCore.Base.Event.Event")

local setting = {
    Elements = {
        {
            Name = "Button",
            Type = CS.UnityEngine.UI.Button,
            Handler = {
                onClick = "OnConfirm"
            }
        },
        {
            Name = "ScrollView",
            Script = "GameLogics.UI.Common.UI_ItemListView"
        }
    }
}

function EmbattlePanel:ctor(obj)
    self.super.ctor(self, obj, setting)
end

function EmbattlePanel:SetData(data)
    self.data = data
    self:RefreshScroll()
end

function EmbattlePanel:OnAwake()
end

function EmbattlePanel:OnStart()
    -- get luabehaviour
    --self.ScrollView = 
end

function EmbattlePanel:RefreshScroll()
    --self.ScrollView:
    self.ScrollView.getFunc = function ( index )
        return self.data[index]
    end
    self.ScrollView:Init("Battle/Embattle/EmbattleItem",200)
end

function EmbattlePanel:OnConfirm()
    --EventManager:Emit("ExcuteCard", 1,1)
end

return EmbattlePanel
