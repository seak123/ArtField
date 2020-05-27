--[[
    author:yaxinge
    time:2020-05-16 18:15:19
]]
local base = require("GameLogics.Battle.Action.Nodes.BaseNode")
---@class SummonNode
local Summon = class("SummonNode", base)
local CardConfig = require("GameLogics.Config.Battle.CardConfig")
local ConfigManager = require("GameCore.Base.Config.ConfigManager")

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
    local vo = ConfigManager.GetUnitConfig(self.vo.unitId)
    local uid = self.sess.field:CreateUnit(vo)
    self.vo.uid = uid
    self.vo.x = param.selectPos.x
    self.vo.z = param.selectPos.y
    return self:Perform()
end

function Summon:Perform()
    local vo = {}
    vo.nodeType = self.vo.nodeType
    ---@type SummonPerformVO
    vo.nodeVO = {}
    vo.nodeVO.uid = self.vo.uid
    vo.nodeVO.prefabPath = CardConfig.UnitPrefab[self.vo.unitId]
    vo.nodeVO.positionX = self.vo.x
    vo.nodeVO.positionZ = self.vo.z
    return vo
end

return Summon
