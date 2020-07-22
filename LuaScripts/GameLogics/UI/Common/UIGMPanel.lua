local LuaBehaviour = require("GameCore.Base.Framework.LuaBehaviour")
---@class UI_Notice:LuaBehaviour
local GM = class("UIGMPanel", LuaBehaviour)
local UIConst = require("GameLogics.Constant.UIConst")
local EventConst = require("GameCore.Constant.EventConst")

local setting = {
    Elements = {
        {
            Name = "Text",
            Alias = "content",
            Type = CS.UnityEngine.UI.Text
        },
        {
            Name = "CloseBtn",
            Type = CS.UnityEngine.UI.Button,
            Handler = {
                onClick = "OnClose"
            }
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

function GM:ctor(obj)
    self.super.ctor(self, obj, setting)
    CS.WindowsUtil.SwitchLayer(obj, UIConst.Layer.MainLayer0)
end

function GM:OnAwake()
end

function GM:OnStart()
end

function GM:SetNotice(content)
    self.content.text = content
end

function GM:OnClose()
    CS.WindowsUtil.RemoveWindow(self._target)
end

return GM
