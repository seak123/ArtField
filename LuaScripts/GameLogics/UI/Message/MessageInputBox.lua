local LuaBehaviour = require("GameCore.Base.Framework.LuaBehaviour")
---@class InpuBox:LuaBehaviour
local InpuBox = class("InpuBox", LuaBehaviour)

local setting = {
    Elements = {
        {
            Name = "InputText",
            Type = CS.UnityEngine.UI.InputText
        },
        {
            Name = "DescText",
            Type = CS.UnityEngine.UI.Text
        },
        {
            Name = "ConfirmBtn",
            Type = CS.UnityEngine.UI.Button,
            Handler = {
                onClick = "OnConfirm"
            }
        },
        {
            Name = "CloseBtn",
            Type = CS.UnityEngine.UI.Button,
            Handler = {
                onClick = "OnClose"
            }
        }
    }
}

function InpuBox:ctor(obj)
    self.super.ctor(self, obj, setting)
    CS.WindowsUtil.SwitchLayer(obj, UIConst.Layer.MainLayer0)
end

function InpuBox:OnAwake()
end

function InpuBox:OnStart()
end

function InpuBox:SetText(content)
    self.DescText.text = content
end

function InpuBox:SetCallBack(callback)
    self.callback = callback
end

function InpuBox:OnConfirm()
    if self.callback then
        self.callback(self.InputText.value)
    end
    self:OnClose()
end

function InpuBox:OnClose()
    CS.WindowsUtil.RemoveWindow(self._target)
end

return InpuBox
