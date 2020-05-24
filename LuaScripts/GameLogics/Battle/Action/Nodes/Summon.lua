--[[
    author:yaxinge
    time:2020-05-16 18:15:19
]]
local base = require("GameLogics.Battle.Action.Nodes.BaseNode")
---@class SummonNode
local Summon = class("SummonNode",base)
local CardConfig = require("GameLogics.Config.Battle.CardConfig")

---@class SummonVO
local SummonVO = {
    id = 1
}

---@param sess BattleSession
---@param vo SummonVO
function Summon:ctor( sess,vo)
    self.sess = sess
    self.vo = vo
end

function Summon:Excute( x,z )
    local vo = nil
    local uid = self.sess.field:CreateUnit(vo)
    self.vo.x = x
    self.vo.z = z
    self:Perform()
end

function Summon:Perform(  )
    local vo = {}
    vo.nodeType = self.vo.NodeType
    vo.nodeVO = {}
    vo.nodeVO.prefabPath = CardConfig.UnitPrefab[self.vo.UnitId]
    vo.nodeVO.positionX = self.vo.x
    vo.nodeVO.positionZ = self.vo.z
    
    EventManager:Emit("PerfomerPushNode",vo)
end

return Summon