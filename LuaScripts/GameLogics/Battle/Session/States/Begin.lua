--[[
    author:yaxinge
    time:2020-03-15 11:13:07
]]

local BaseState = require("GameLogics.Battle.Session.States.BaseState")
---@class BeginState:BaseState
local BeginState = class("BeginState",BaseState)
local FSM = require("GameLogics.Battle.Session.SessionFSM")

---@param sess BattleSession
function BeginState:ctor(sess)
    self.sess = sess
    self.next = -1
end

function BeginState:Enter()
    --初始化镜头
    CS.CameraManager.Instance:InitSceneCamera(BattleManager.session.sceneId)
    self.next = FSM.SessionType.EmbattleHero
end

function BeginState:Update()
end

return BeginState
