--[[
    author:yaxinge
    time:2020-04-25 21:21:23
]]
local BattleMng = class("BattleManager")
local BattleSession = require("GameLogics.Battle.Session.BattleSession")

function BattleMng:ctor()
    self.session = nil
end

function BattleMng:StartBattle(battleVO)
    Debug.Log("[BattleManger] StartBattle ",battleVO)
    self.session = BattleSession.new(battleVO)
    self.session:Init()
end

function BattleMng:ExitBattle()
    self.session:CleanUp()
    self.session = nil
end

return BattleMng
