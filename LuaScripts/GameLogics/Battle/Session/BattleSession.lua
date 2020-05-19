---@class BattleSession
---@field field BattleField
local BattleSession = class("BattleSession")
local FSM = require("GameLogics.Battle.Session.SessionFSM")
local BeginState = require("GameLogics.Battle.Session.States.Begin")
local EmbattleState = require("GameLogics.Battle.Session.States.Embattle")
local ScheduleState = require("GameLogics.Battle.Session.States.Schedule")
local ActionState = require("GameLogics.Battle.Session.States.ActionState")
local PlayCardState = require("GameLogics.Battle.Session.States.PlayCard")
local FinalState = require("GameLogics.Battle.Session.States.Final")
local MapMng = require("GameLogics.Battle.Map.MapManager")
local BattleField = require("GameLogics.Battle.Field.BattleField")
local EventConst = require("GameCore.Constant.EventConst")

function BattleSession:ctor(vo)
    self.vo = vo
end

function BattleSession:Init()
    self.sceneId = self.vo.id
    self.myHeros = self.vo.myHeros
    self.map = MapMng.new(self)
    
    self.field = BattleField.new(self)
    CS.BattleManager.Instance:StartBattle()

    self.field:CreateHeroCards(self.myHeros)

    self.fsm = FSM.new()
    self.fsm:RegisterState(FSM.SessionType.Begin, BeginState.new(self))
    self.fsm:RegisterState(FSM.SessionType.EmbattleHero, EmbattleState.new(self))
    self.fsm:RegisterState(FSM.SessionType.Schedule, ScheduleState.new(self))
    self.fsm:RegisterState(FSM.SessionType.PlayCard, PlayCardState.new(self))
    self.fsm:RegisterState(FSM.SessionType.Action, ActionState.new(self))
    self.fsm:RegisterState(FSM.SessionType.Final, FinalState.new(self))

    self.fsm:Switch2State(FSM.SessionType.Begin)

    EventManager:On(EventConst.ON_SCHEDULER_UPDATE, self.Update, self)
end

function BattleSession:Update(delta)
    self.fsm:Update(delta)
end

function BattleSession:CleanUp()
end

return BattleSession
