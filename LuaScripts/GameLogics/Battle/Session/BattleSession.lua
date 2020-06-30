---@class BattleSession
---@field field BattleField
local BattleSession = class("BattleSession")
local FSM = require("GameLogics.Battle.Session.SessionFSM")
local PreBattleState = require("GameLogics.Battle.Session.States.PreBattle")
local BeginState = require("GameLogics.Battle.Session.States.Begin")
local EmbattleState = require("GameLogics.Battle.Session.States.Embattle")
local ActionState = require("GameLogics.Battle.Session.States.ActionState")
local FinalState = require("GameLogics.Battle.Session.States.Final")
local MapMng = require("GameLogics.Battle.Map.MapManager")
local BattleField = require("GameLogics.Battle.Field.BattleField")
local EventConst = require("GameCore.Constant.EventConst")

---@class BattleSessionVO
local BattleSessionVO = {}

function BattleSession:ctor(vo)
    self.vo = vo
end

function BattleSession:Init()
    self.sceneId = self.vo.id
    self.curTime = os.time()
    math.randomseed(self.curTime)
    self.myHeros = self.vo.myHeros
    self.map =
        MapMng.new(
        self,
        {
            width = 16,
            height = 16
        }
    )

    self.field = BattleField.new(self)
    if not SystemConst.logicMode then
        CS.BattleManager.Instance:StartBattle()
    end

    self.field:InjectData(self.myHeros)
    self.state = nil

    self.fsm = FSM.new(self)
    self.fsm:RegisterState(FSM.SessionType.PreBattle, PreBattleState.new(self))
    self.fsm:RegisterState(FSM.SessionType.Begin, BeginState.new(self))
    self.fsm:RegisterState(FSM.SessionType.Embattle, EmbattleState.new(self))
    self.fsm:RegisterState(FSM.SessionType.Action, ActionState.new(self))
    self.fsm:RegisterState(FSM.SessionType.Final, FinalState.new(self))

    self.fsm:Switch2State(FSM.SessionType.PreBattle)

    EventManager:On(EventConst.ON_SCHEDULER_UPDATE, self.Update, self)
end

function BattleSession:Update(delta)
    self.fsm:Update(delta)
    self.field:Update(delta)
    self.map:Update(delta)

    self.curTime = self.curTime + delta
end

function BattleSession:CleanUp()
    EventManager:Off(EventConst.ON_SCHEDULER_UPDATE, self.Update,self)
    if not SystemConst.logicMode then
        CS.BattleManager.Instance:LeaveBattle()
    end
end

function BattleSession:CurrentState()
    return self.fsm.currState
end

return BattleSession
