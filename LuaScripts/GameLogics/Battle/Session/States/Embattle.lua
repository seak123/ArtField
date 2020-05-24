--[[
    author:yaxinge
    time:2020-05-02 23:38:55
]]
local BaseState = require("GameLogics.Battle.Session.States.BaseState")
---@class EmbattleState
local EmbattleState = class("EmbattleState", BaseState)
local CardExcutor = require("GameLogics.Battle.Field.Card.CardExcutor")

function EmbattleState:ctor(sess)
    ---@type BattleSession
    self.sess = sess
    self.next = -1
end

function EmbattleState:Enter()
    --初始化布阵面板
    self.sess.field.cardExcutor:SwitchState(CardExcutor.State.Hero)
end

function EmbattleState:Update()
end

return EmbattleState
