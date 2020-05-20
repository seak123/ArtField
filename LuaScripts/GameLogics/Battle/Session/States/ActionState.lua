--[[
    author:yaxinge
    time:2020-05-16 10:29:48
]]
local BaseState = require("GameLogics.Battle.Session.States.BaseState")
---@class ActionState:BaseState
local ActionState = class("ActionState",BaseState)
local FSM = require("GameLogics.Battle.Session.SessionFSM")

---@return ActionState
---@param sess BattleSession
function ActionState:New(sess)
    return self.new(sess)
end

---@param sess BattleSession
function ActionState:ctor(sess)
    self.sess = sess
    self.next = -1
end

function ActionState:Enter()
    --self.next = FSM.SessionType.Embattle
end

function ActionState:Update()
end

return ActionState