---@class BuffManager
local Mng = class("BuffManager")
---@class BuffInstance
local BuffInstance = class("BuffInstance")
local Buff = require("GameLogics.Battle.SpellAction.Actions.BuffSp")
local Condition = require("GameLogics.Battle.Field.Unit.Components.ConditionController")

------------------- buff instance --------------------
function BuffInstance:ctor(master, vo)
    self.master = master
    self.vo = vo
    self:Init()
end

function BuffInstance:Init()
    self.duration = self.vo.duration
    self.isForever = self.duration < 0
end

function BuffInstance:Update(delta)
    self.duration = self.duration - delta
end

function BuffInstance:IsActive()
    return self.isForever or self.duration > 0
end

---------- buff function define -----------
BuffInstance.changeDefines = {
    [Buff.Features.Condition] = {
        onAdd = function(master, vo)
            master.condition:AddState(Condition.StateType[vo.state])
        end,
        onRemove = function(master, vo)
            master.condition:RemoveState(Condition.StateType[vo.state])
        end
    }
}

function BuffInstance:OnAdd()
    for i = 1, #self.vo.features do
        BuffInstance.changeDefines[self.vo.features[i].type].onAdd(self.master, self.vo.features[i])
    end
end

function BuffInstance:OnRemove()
    for i = 1, #self.vo.features do
        BuffInstance.changeDefines[self.vo.features[i].type].onRemove(self.master, self.vo.features[i])
    end
end

------------------ buff manager ------------------

function Mng:ctor(master)
    self.master = master
    self.uid = 0

    self:Init()
end

function Mng:Init()
    self.buffs = {}
end

function Mng:Update(delta)
    for uid, inst in pairs(self.buffs) do
        inst:Update(delta)
        if not inst:IsActive() then
            self:RemoveBuff(uid)
        end
    end
end

function Mng:AddBuff(buffVO)
    local instance = BuffInstance.new(self.master, buffVO)
    self.uid = self.uid + 1
    instance.uid = self.uid
    self.buffs[instance.uid] = instance
    instance:OnAdd()
    Debug.Log(self.master.name.." ADD buff [",buffVO.name,"]")
end

function Mng:RemoveBuff(uid)
    if self.buffs[uid] ~= nil then
        Debug.Log(self.master.name.." Remove buff [",self.buffs[uid].vo.name,"]")
        self.buffs[uid]:OnRemove()
        self.buffs[uid] = nil
    end
end

function Mng:CleanUp()
    for uid, inst in pairs(self.buffs) do
        self:RemoveBuff(uid)
    end
end

return Mng
