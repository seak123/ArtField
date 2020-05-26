--[[
    author:yaxinge
    time:2020-05-05 10:55:01
]]
local LuaBehaviour = require("GameCore.Base.Framework.LuaBehaviour")
local EmbattleItem = class("EmbattleItem", LuaBehaviour)
local UIConst = require("GameLogics.Constant.UIConst")
local CardCfg = require("GameLogics.Config.Battle.CardConfig")

local setting = {
    Elements = {
        -- {
        --     Name = "Button",
        --     Type = CS.UnityEngine.UI.Button,
        --     Handler = {
        --         onClick = "OnSelect"
        --     }
        -- },
        {
            Name = "Button/Name",
            Alias = "Name",
            Type = CS.UnityEngine.UI.Text
        }
    }
}

function EmbattleItem:ctor(obj)
    self.super.ctor(self, obj, setting)
end

function EmbattleItem:SetData(data)
    self.data = data
    self.Name.text = self.data.cardName

    local cardScript = self._target:GetComponent(typeof(CS.CardItem))
    cardScript:InjectData(self.data)
end

function EmbattleItem:OnAwake()
end

function EmbattleItem:OnStart()
end

return EmbattleItem
