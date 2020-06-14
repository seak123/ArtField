---@class EffectExecutor
local SpellExecutor = class("SpellExecutor")
local SpellInstance = require("GameLogics.Battle.Field.Effect.SpellInstance")

function SpellExecutor:ctor(sess)
    self.sess = sess
    self.runSpells = {}
end

function SpellExecutor:ExecuteSpell(spellVO, targetParams)
    local newSpell = SpellInstance.new(self.sess, spellVO, targetParams)
    table.insert(self.runSpells, newSpell)
end

function SpellExecutor:Update(delta)
    for i = #self.runSpells, 1, -1 do
        self.runSpells[i]:Update(delta)
        if self.runSpells[i]:IsFinish() then
            table.remove(self.runSpells,i)
        end
    end
end

return SpellExecutor
