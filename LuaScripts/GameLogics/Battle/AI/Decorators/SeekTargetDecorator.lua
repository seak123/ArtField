---@class SeekTargetDecorator
local SeekTarget = class("SeekTargetDecorator")

SeekTarget.SeekType = {
    NearestEnemy = "NearestEnemy",
    FarthestEnemy = "FarthestEnemy"
}

SeekTarget.ExecuteMap = {
    [SeekTarget.SeekType.NearestEnemy] = SeekTarget.NearestEnemyFinder,
    [SeekTarget.SeekType.FarthestEnemy] = SeekTarget.FarthestEnemyFinder
}

function SeekTarget:ctor(parent)
    self.parent = parent
end

function SeekTarget:Execute()
end

function SeekTarget:NearestEnemyFinder()
    local master = self.parent.tree.master
    ---@type BattleField
    local field = master.sess.field
    ---@type MapManager
    local map = master.sess.map
    local nearstDist = 999
    local nearstUnit = nil
    local searchFunc = function(unit)
        local dist = map:GetDist(master:GetPos(),unit)
        if dist < nearstDist then
            nearstDist = dist
            nearstUnit = unit
        end
    end
    field:UnitForeach(searchFunc)
    if nearstUnit ~= nil then
        self.parent.targetPos = nearstUnit:GetPos()
        return true
    else
        --cannot find target
        return false
    end
end

function SeekTarget:FarthestEnemyFinder()
end

return SeekTarget
