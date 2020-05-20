local LuaBehaviour = require("GameCore.Base.Framework.LuaBehaviour")
---@class UI_Notice:LuaBehaviour
local UI_Notice = class("UI_Notice", LuaBehaviour)
local UIConst = require("GameLogics.Constant.UIConst")
local EventConst = require("GameCore.Constant.EventConst")

local setting = {
    Elements = {
        {
            Name = "Text",
            Alias = "content",
            Type = CS.UnityEngine.UI.Text
        }
    },
    Timers = {
        {
            Name = "UINoticeAutoHide",
            Timer = {3, false},
            Handler = "Remove"
        }
    },
    Events = {
        {
            Name = EventConst.ON_CREATE_NOTICE,
            Handler = "OnCreateNewNotice"
        }
    }
}
---@return UI_Notice
function UI_Notice:New()
    return self.new()
end

function UI_Notice:ctor(obj)
    self.super.ctor(self, obj, setting)
    CS.WindowsUtil.SwitchLayer(obj, UIConst.UILayer.NoticeLayer)
end

function UI_Notice:OnAwake()
end

function UI_Notice:OnStart()
end

function UI_Notice:SetNotice(content)
    self.content.text = content
end

function UI_Notice:Remove()
    CS.WindowsUtil.RemoveWindow(self._target)
end

function UI_Notice:OnCreateNewNotice()
    local pos = self._target.transform.position
    self._target.transform.position = CS.UnityEngine.Vector3(pos.x, pos.y + 30, pos.z)
end

return UI_Notice
