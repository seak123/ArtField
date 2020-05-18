--[[
    author:yaxinge
    time:2020-05-16 10:28:37
]]
local BaseState = require("GameLogics.Battle.Session.States.BaseState")
local PlayCardState = class("PlayCardState",BaseState)
local FSM = require("GameLogics.Battle.Session.SessionFSM")

function PlayCardState:ctor(sess)
    self.sess = sess
    self.next = -1
end

function PlayCardState:Enter()
    --self.next = FSM.SessionType.Embattle
end

function PlayCardState:Update()
end

return PlayCardState