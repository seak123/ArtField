local LuaBehaviour = require("GameCore.Base.Framework.LuaBehaviour")
local MainUI = class("MainUI", LuaBehaviour)
local UIConst = require("GameLogics.Constant.UIConst")

local setting = {
    Elements = {
        {
            Name = "BattleBtn",
            Type = CS.UnityEngine.UI.Button,
            Handler = {
                onClick = "OnBattleBtn"
            }
        },
        {
            Name = "DrawCardBtn",
            Type = CS.UnityEngine.UI.Button,
            Handler = {
                onClick = "OnDrawCardBtn"
            }
        }
    }
}

function MainUI:ctor(obj)
    self.super.ctor(self, obj, setting)
    MainUIManager.mainUI = self
end

function MainUI:OnAwake()
    --self.DrawCardBtn.interactable = false;
end

function MainUI:OnStart()
end

function MainUI:OnBattleBtn()
    -- CS.WindowsUtil.AddWindowAsync("Common/UI_Notice",function ( obj )
    --     print(("async!!!"))
    --     if obj ~= nil then print("not nil") end
    --     print(obj:GetInstanceID());
    --    local lb= __BehaviourManager:GetBehaviour(obj:GetInstanceID())
    --    lb:SetNotice("Fuck")
    -- end)
    CS.GameSceneManager.Instance:AddSceneLoadedOnceListener(
        function()
            MainUIManager.Hide()
            BattleManager:StartBattle({id = 1, myHeros = {{1}, {1}}})
        end
    )
    CS.SceneUtil.SwitchScene("DemoBattleScene", nil)
end

function MainUI:OnDrawCardBtn()
    NoticeManager.Notice("抽卡功能未开发")
end

return MainUI
