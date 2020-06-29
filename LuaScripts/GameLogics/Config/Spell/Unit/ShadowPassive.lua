local VO = require("GameLogics.Battle.Field.Effect.SpellVO")
local this = {}

this.behavior = VO.SpellBehavior.Passive + VO.SpellBehavior.Immediate
this.events = {
    {
        name = VO.SpellEvents.OnSpellStart,
        actions = {
            {
                type = "BuffSp",
                name = "伺机待发",
                duration = 2,
                owner = "Caster",
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
