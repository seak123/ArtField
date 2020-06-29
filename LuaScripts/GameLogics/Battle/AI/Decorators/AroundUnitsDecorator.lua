---@class AroundUnitsDecorator
local AroundUnits = class("AroundUnitsDecorator")
local Condition = require("GameLogics.Battle.Field.Unit.Components.ConditionController")


AroundUnits.findType = {
    Enemy = "Enemy",
    Friend = "Friend",
    EveryBody = "EveryBody"
}


function AroundUnits:ctor(parent,vo)
    self.parent = parent
    self.findType = vo.findType
    self.needCount = vo.needCount and vo.needCount or 0
end

function AroundUnits:Execute()
    return self:AroundFinder()
end

function AroundUnits:AroundFinder()
    local master = self.parent.tree.master
    ---@type BattleField
    local field = master.sess.field
    ---@type MapManager
    local map = master.sess.map
    local checker
    if self.findType == AroundUnits.findType.Enemy then
        checker = function(unit)
            return unit.camp == 3 - master.camp
        end
    elseif self.findType == AroundUnits.findType.Friend then
        checker = function(unit)
            return unit.camp == master.camp
        end
    elseif self.findType == AroundUnits.findType.EveryBody then
        checker = function(unit)
            return true
        end
    end
    local count = 0
    local searchFunc = function(unit)
        if checker(unit) then
            if unit.condition:hasState(Condition.StateType.Steal) then
                --有隐身状态则跳过
                return
            end
            count = count + 1
        end
    end
    field:UnitForeach(searchFunc)
    if count >= self.needCount then
        return true
    else
        --cannot find enough target
        return false
    end
end

return AroundUnits
