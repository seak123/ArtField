local base = require("GameLogics.Battle.SpellAction.Actions.BaseSp")
---@class BuffSp
local Buff = class("BuffSp", base)

Buff.Features = {
    Condition = "Condition",
    Property = "Property"
}


---@param sess BattleSession
---@param vo DamageVO
function Buff:ctor(sess, vo, params)
    self.sess = sess
    self.vo = vo
    self.params = params
end

function Buff:Update(delta)
    ---@type Creature
    local caster = self.params.caster
    local target = self.params.target
    local buffVO = {
        name = self.vo.name,
        duration = self.vo.duration,
        features = self.vo.features
    }
    local owner = self.vo.owner == "Caster" and caster or target
    owner.buffMng:AddBuff(buffVO)
    return true
end

return Buff
