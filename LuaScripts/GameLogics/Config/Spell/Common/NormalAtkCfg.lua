local VO = require("GameLogics.Battle.Field.Effect.SpellVO")
local this = {}

this.behavior = VO.SpellBehavior.Immediate
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

return this
