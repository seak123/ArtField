local VO = require("GameLogics.Battle.Field.Effect.SpellVO")
local this = {}

this.behavior = VO.SpellBehavior.Projectile
this.events = {
    {
        name = VO.SpellEvents.OnSpellStart,
        actions = {
            {
                type = "DamageSp",
                damageType = "Normal",
                damageFeature = "Physic"
            }
        }
    }
}
this.projectileSpeed = 5
this.projectileASpeed = 2

return this
