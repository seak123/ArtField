---@class SpellInstance
local Spell = class("SpellInstance")
local Event = require("GameCore.Base.Event.Event")

Spell.States = {
    DeActive = 0,
    Begin = 1,
    Running = 2,
    Finish = 3
}

function Spell:ctor(sess, vo, targetParams)
    self.sess = sess
    self.vo = vo
    self.state = Spell.States.DeActive
    self.behavior = vo.behavior
    self.actions = {}
    self.params = targetParams

    self.eventMap = {}
    self:BindEvents()
end

function Spell:Update(delta)
    self:UpdateActions(delta)
    self:CheckState()
end

function Spell:RegisterEvent(name, handler)
    if self.eventMap[name] == nil then
        self.eventMap[name] = {}
        self.eventMap[name] = Event.new(name)
    end
    self.eventMap[name]:Bind(handler)
end

function Spell:InvokeEvent(name)
    if self.eventMap[name] then
        self.eventMap[name]:Fire()
    end
end

function Spell:BindEvents()
    for i = 1, #self.vo.events do
        for k = 1, #self.vo.events[i].actions do
            self:RegisterEvent(
                self.vo.events[i].name,
                Handle:new(
                    function()
                        self:DoAction(self.vo.events[i].actions[k])
                    end
                )
            )
        end
    end
end

function Spell:DoAction(actVO)
    local node = require("GameLogics.Battle.SpellAction.Actions." .. actVO.type).new(self.sess, actVO, self.params)
    table.insert(self.actions, node)
end

function Spell:CheckState()
    if self.state == Spell.States.DeActive then
        self.state = Spell.States.Begin
        return
    elseif self.state == Spell.States.Begin then
        self:InvokeEvent("OnSpellStart")
        self.state = Spell.States.Running
    elseif self.state == Spell.States.Running then
        if #self.actions == 0 then
            self.state = Spell.States.Finish
        end
    end
end

function Spell:UpdateActions(delta)
    for i = #self.actions, 1, -1 do
        if self.actions[i]:Update(delta) then
            self.actions[i]:Clean()
            table.remove(self.actions, i)
        end
    end
end

function Spell:IsFinish()
    return self.state == Spell.States.Finish
end

return Spell
