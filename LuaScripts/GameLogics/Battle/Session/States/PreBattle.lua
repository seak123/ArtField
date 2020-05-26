
local BaseState = require("GameLogics.Battle.Session.States.BaseState")
---@class PreBattle:BaseState
local PreBattle = class("PreBattle",BaseState)
local FSM = require("GameLogics.Battle.Session.SessionFSM")

PreBattle.type = FSM.SessionType.PreBattle

---@param sess BattleSession
function PreBattle:ctor(sess)
    self.sess = sess
    self.next = -1
end

function PreBattle:Enter()
     --初始化镜头
     CS.CameraManager.Instance:InitSceneCamera(BattleManager.session.sceneId)
    self.next = FSM.SessionType.Begin
end

function PreBattle:Update()
end

return PreBattle
