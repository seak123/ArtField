---@class SeekTargetDecorator
local SeekTarget = class("SeekTargetDecorator")

SeekTarget.SeekType = {
    NearestEnemy = "NearestEnemy",
    FarthestEnemy = "FarthestEnemy"
}

SeekTarget.ExecuteMap = {
    [SeekTarget.SeekType.NearestEnemy] = "NearestEnemyFinder",
    [SeekTarget.SeekType.FarthestEnemy] = "FarthestEnemyFinder"
}

function SeekTarget:ctor(parent,vo)
    self.parent = parent
    self.seekType = vo.seekType
end

function SeekTarget:Execute()
    return SeekTarget[SeekTarget.ExecuteMap[self.seekType]](self)
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
        if unit.camp == 3 - master.camp then
            local dist = map:GetDist(master:GetPos(), unit:GetPos())
            if dist < nearstDist then
                nearstDist = dist
                nearstUnit = unit
            end
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
    local master = self.parent.tree.master
    ---@type BattleField
    local field = master.sess.field
    ---@type MapManager
    local map = master.sess.map
    local farthstDist = 0
    local farthstUnit = nil
    local searchFunc = function(unit)
        if unit.camp == 3 - master.camp then
            local dist = map:GetDist(master:GetPos(), unit:GetPos())
            if dist > farthstDist then
                farthstDist = dist
                farthstUnit = unit
            end
        end
    end
    field:UnitForeach(searchFunc)
    if farthstUnit ~= nil then
        self.parent.targetPos = farthstUnit:GetPos()
        return true
    else
        --cannot find target
        return false
    end
end

return SeekTarget
