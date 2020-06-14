--[[
    author:yaxinge
    time:2020-05-02 23:38:55
]]
local BaseState = require("GameLogics.Battle.Session.States.BaseState")
---@class EmbattleState
local EmbattleState = class("EmbattleState", BaseState)
local CardExecutor = require("GameLogics.Battle.Field.Card.CardExecutor")
local FSM = require("GameLogics.Battle.Session.SessionFSM")

EmbattleState.type = FSM.SessionType.EmbattleHero

function EmbattleState:ctor(sess)
    ---@type BattleSession
    self.sess = sess
    self.next = -1
end

function EmbattleState:Enter()
    --初始化布阵面板
    self.sess.field.cardExecutor:SwitchState(CardExecutor.State.Hero)
    self.sess.field.cardExecutor.cardPanelLb:SetBtnText("开战")

    local func = function()
        self.next = FSM.SessionType.Action
    end

    self.sess.field.cardExecutor.cardPanelLb:SetBtnCallback(func)
end

function EmbattleState:Update()
end

function EmbattleState:Leave()
    self.sess.field.cardExcutor.cardPanelLb:SetBtnCallback(nil)
end

return EmbattleState
