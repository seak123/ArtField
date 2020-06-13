---@class EffectExecutor
local SpellExecutor = class("SpellExecutor")

function SpellExecutor:ctor(sess)
    self.sess = sess
end

function SpellExecutor:ExecuteSpell()
end

function SpellExecutor:Update(delta)
end

return SpellExecutor