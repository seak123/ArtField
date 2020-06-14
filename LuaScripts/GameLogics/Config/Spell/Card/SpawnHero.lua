local base = require("GameLogics.Battle.Field.Effect.SpellVO")
---@type SpellVO
local this = class("SpawnHero", base)

function this:ctor(param1)
    self.behavior = base.SpellBehavior.Command
    self.events = {
        {
            name = base.SpellEvents.OnSpellStart,
            actions = {
                {
                    type = "SummonAction",
                    unitId = param1,
                }
            }
        }
    }
end

return this
