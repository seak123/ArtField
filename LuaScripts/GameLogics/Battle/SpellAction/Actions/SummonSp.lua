local base = require("GameLogics.Battle.SpellAction.Actions.BaseSp")
---@class SummonSp
local Summon = class("SummonSp", base)

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
