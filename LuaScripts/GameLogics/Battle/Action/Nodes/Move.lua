
local base = require("GameLogics.Battle.Action.Nodes.BaseNode")
---@class MoveNode
local Move = class("MoveNode", base)
local CardConfig = require("GameLogics.Config.Battle.CardConfig")

Move.MoveType = {
    Walk = 1, --常规移动
    convey = 2, --技能位移
}
---@class MoveVO
local MoveVO = {
    uid = 1,
    type = Move.MoveType.Walk,
    path = {},
}
---@class MovePerformVO
local MovePerformVO = {
    uid = 0,
    path = {},
    goalX = 0,
    goalZ = 0
}


---@param sess BattleSession
---@param vo MoveVO
function Move:ctor(sess, vo)
    self.sess = sess
    self.vo = vo
end

function Move:Excute(param)
    ---@type UnitVO
    local vo = ConfigManager:GetUnitConfig(self.vo.unitId)
    local uid = self.sess.field:CreateUnit(vo)
    self.vo.uid = uid
    self.vo.x = param.selectPos.x
    self.vo.z = param.selectPos.y
    return self:Perform(vo)
end

---@param unitVO UnitVO
function Move:Perform(unitVO)
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

return Move
