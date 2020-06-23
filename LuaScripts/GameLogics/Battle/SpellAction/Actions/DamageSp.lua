local base = require("GameLogics.Battle.SpellAction.Actions.BaseSp")
---@class DamageSp
local Damage = class("DamageSp", base)

Damage.DamageType = {
    Normal = "Normal",
    Spell = "Spell"
}

Damage.DamageFeature = {
    Physic = "Physic",
    Magic = "Magic",
    Real = "Real"
}

---@param sess BattleSession
---@param vo DamageVO
function Damage:ctor(sess, vo, params)
    self.sess = sess
    self.vo = vo
    self.params = params
end

function Damage:Update(delta)
    ---@type Creature
    local caster = self.params.caster
    local target = self.params.target
    local value
    if self.vo.damageType == "Normal" then
        value = caster.properties:GetProperty("attack")
    end
    value = Math.damageCal(value,self.vo.damageFeature)
    Debug.Log(caster.name.." make attack on "..target.name.." <"..value.."> damage")
    target:Damage(value,caster)
    return true
end

return Damage
