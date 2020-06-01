--[[
    author:yaxinge
    time:2020-05-16 18:15:19
]]
local base = require("GameLogics.Battle.Action.Nodes.BaseNode")
---@class SummonNode
local Summon = class("SummonNode", base)
local CardConfig = require("GameLogics.Config.Battle.CardConfig")

Summon.SummonType = {
    Hero = 1, --召唤英雄
    Creature = 2, --召唤生物
}
---@class SummonVO
local SummonVO = {
    unitId = 1,
    type = Summon.SummonType.Creature,
}
---@class SummonPerformVO
local SummonPerformVO = {
    uid = 0,
    prefabPath = "",
    positionX = "",
    positionZ = ""
}


---@param sess BattleSession
---@param vo SummonVO
function Summon:ctor(sess, vo)
    self.sess = sess
    self.vo = vo
end

function Summon:Excute(param)
    ---@type UnitVO
    local vo = ConfigManager:GetUnitConfig(self.vo.unitId)
    local uid = self.sess.field:CreateUnit(vo)
    self.vo.uid = uid
    self.vo.x = param.selectPos.x
    self.vo.z = param.selectPos.y
    return self:Perform(vo)
end

---@param unitVO UnitVO
function Summon:Perform(unitVO)
    local vo = {}
    vo.nodeType = self.vo.nodeType
    ---@type SummonPerformVO
    vo.nodeVO = {}
    vo.nodeVO.uid = self.vo.uid
    vo.nodeVO.unitVO = unitVO
    vo.nodeVO.positionX = self.vo.x
    vo.nodeVO.positionZ = self.vo.z
    return vo
end

return Summon
