---@class PlayerManager
local PlayerMng = class("PlayerManager")
local EventConst = require("GameCore.Constant.EventConst")

function PlayerMng:ctor()
    self.level = 1

    EventManager:On(EventConst.ON_BATTLE_RESULT, self.OnBattleResult, self)
end

function PlayerMng:GetCurLevel()
    return self.level
end

function PlayerMng:OnBattleResult(result)
    if result == 1 then
        self.level = self.level + 1
    end
end

return PlayerMng
