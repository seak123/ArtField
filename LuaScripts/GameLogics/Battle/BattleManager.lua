--[[
    author:yaxinge
    time:2020-04-25 21:21:23
]]
---@class BattleManager

local BattleMng = class("BattleManager")
local BattleSession = require("GameLogics.Battle.Session.BattleSession")

function BattleMng:ctor()
    ---@field session BattleSession
    self.session = nil
end

function BattleMng:StartBattle(battleVO)
    Debug.Log("[BattleManger] StartBattle ", battleVO)
    self.session = BattleSession.new(battleVO)
    self.session:Init()
end

function BattleMng:ExitBattle()
    if self.session ~= nil then
        self.session:CleanUp()
    end
    self.session = nil
end

function BattleMng:JumpStartBattle(level)
    if level <= 0 or level > ConfigManager:GetLevelNum() then
        return NoticeManager.Notice("找不到关卡")
    end
    self:ExitBattle()
    PlayerManager.level = level
    self:StartBattle({id = 1, level = PlayerManager:GetCurLevel()})
end

return BattleMng
