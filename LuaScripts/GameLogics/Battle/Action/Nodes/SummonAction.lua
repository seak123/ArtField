local base = require("GameLogics.Battle.Action.Nodes.BaseAction")
---@class SummonNode
local Summon = class("SummonNode", base)
local CardConfig = require("GameLogics.Config.Battle.CardConfig")

---@param sess BattleSession
---@param vo SummonVO
function Summon:ctor(sess, vo, params)
    self.sess = sess
    self.vo = vo
    self.params = params
end

function Summon:Update(delta)
    ---@type UnitVO
    local vo = ConfigManager:GetUnitConfig(self.vo.unitId)
    vo.initPos = {
        x = self.params.point.x,
        y = self.params.point.y
    }
    self.sess.field:CreateUnit(vo)
    return true
end

return Summon
