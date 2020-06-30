--[[
    author:yaxinge
    time:2020-05-16 10:29:48
]]
local BaseState = require("GameLogics.Battle.Session.States.BaseState")
---@class ActionState:BaseState
local ActionState = class("ActionState",BaseState)
local FSM = require("GameLogics.Battle.Session.SessionFSM")
local EventConst = require("GameCore.Constant.EventConst")

---@param sess BattleSession
function ActionState:ctor(sess)
    self.sess = sess
    self.next = -1
end

function ActionState:Enter()
    --self.next = FSM.SessionType.Embattle
    EventManager:Emit(EventConst.ON_ENTER_ACTION)
end

function ActionState:Update()
    local result = self.sess.field:CheckBattleResult()
    if result >=0 then
        Debug.Warn("Battle is over, result is "..tostring(result))
        self.next = FSM.SessionType.Final
    end
end

return ActionState