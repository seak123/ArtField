--[[
    author:yaxinge
    time:2020-03-15 11:13:07
]]
local BaseState = require("GameLogics.Battle.Session.States.BaseState")
---@class BeginState:BaseState
local BeginState = class("BeginState", BaseState)
local FSM = require("GameLogics.Battle.Session.SessionFSM")
local EventConst = require("GameCore.Constant.EventConst")

BeginState.type = FSM.SessionType.Begin

---@param sess BattleSession
function BeginState:ctor(sess)
    self.sess = sess
    self.next = -1
end

function BeginState:Enter()
    --初始化游戏内容
    local units = self.sess.lvlCfg.units
    for i = 1, #units do
        local vo = ConfigManager:GetUnitConfig(units[i].unitId)
        vo.initPos = {
            x = units[i].x,
            z = units[i].z
        }
        BattleManager.session.field:CreateUnit(vo, units[i].camp)
    end

    NoticeManager.Notice("本关卡可置放" .. self.sess.unitLimit .. "个单位")

    self.next = FSM.SessionType.Embattle
end

function BeginState:Update()
end

return BeginState
