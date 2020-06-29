--[[
    author:yaxinge
    time:2020-05-02 23:43:08
]]
local BaseState = require("GameLogics.Battle.Session.States.BaseState")
---@class FinalState
local FinalState = class("FinalState", BaseState)
local FSM = require("GameLogics.Battle.Session.SessionFSM")

function FinalState:ctor(sess)
    self.sess = sess
    self.next = -1
end

function FinalState:Enter()
    if not SystemConst.logicMode then
        CS.WindowsUtil.AddWindow("Battle/UI_Final", CS.UILayer.MainLayer_0)
    else
        -- clear session
        BattleManager:ExitBattle()
    end
end

function FinalState:Update()
end

return FinalState
