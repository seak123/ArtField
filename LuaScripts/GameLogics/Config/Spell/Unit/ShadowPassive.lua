local VO = require("GameLogics.Battle.Field.Effect.SpellVO")
local this = {}

this.behavior = VO.SpellBehavior.Passive + VO.SpellBehavior.Immediate
this.events = {
    {
        name = VO.SpellEvents.OnSpellStart,
        actions = {
            {
                type = "BuffSp",
                duration = 2,
                Owner = "Caster",
                features = {
                    {
                        type = "Condition",
                        state = "Steal"
                    }
                }
            }
        }
    }
}

return this
