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
    local nextLevel = nil
    if BattleManager.session.vo.level then
        nextLevel = PlayerManager:GetCurLevel()
    end

    BattleManager:ExitBattle()
    if nextLevel > ConfigManager:GetLevelNum() then
        NoticeManager.Notice("已全部挑战")
    else
        BattleManager:StartBattle({id = 1, level = nextLevel})
        CS.WindowsUtil.RemoveWindow(self._target)
    end
end

function UIFinal:OnClickExit()
    CS.LuaCallCSharpUtil.QuitGame()
end

return UIFinal
