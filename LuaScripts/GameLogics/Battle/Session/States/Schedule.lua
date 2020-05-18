--[[
    author:yaxinge
    time:2020-05-02 23:42:44
]]
local BaseState = require("GameLogics.Battle.Session.States.BaseState")
local ScheduleState = class("ScheduleState",BaseState)
local FSM = require("GameLogics.Battle.Session.SessionFSM")

function ScheduleState:ctor(sess)
    self.sess = sess
    self.next = -1
end

function ScheduleState:Enter()
    --self.next = FSM.SessionType.Embattle
end

function ScheduleState:Update()
end

return ScheduleState