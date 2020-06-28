local LuaBehaviour = require("GameCore.Base.Framework.LuaBehaviour")
---@class UIFinal
local UIFinal = class("EmbattlePanel", LuaBehaviour)
local UIConst = require("GameLogics.Constant.UIConst")
local Event = require("GameCore.Base.Event.Event")

local setting = {
    Elements = {
        {
            Name = "Button",
            Type = CS.UnityEngine.UI.Button,
            Handler = {
                onClick = "OnClickButton"
            }
        },
        {
            Name = "Exit",
            Type = CS.UnityEngine.UI.Button,
            Handler = {
                onClick = "OnClickExit"
            }
        }
    }
}

function UIFinal:ctor(obj)
    self.super.ctor(self, obj, setting)
end

function UIFinal:OnAwake()
end

function UIFinal:OnStart()
    -- get luabehaviour
    --self.ScrollView =
end

function UIFinal:OnClickButton()
    BattleManager:ExitBattle()
    BattleManager:StartBattle({id = 1, myHeros = {{1,2,3,4}, {1,2,3,4}}})
    CS.WindowsUtil.RemoveWindow(self._target)
end

function UIFinal:OnClickExit()
    CS.LuaCallCSharpUtil.QuitGame()
end

return UIFinal
