--[[
    author:yaxinge
    time:2020-04-27 22:24:13
]]
---@class MapManager
local MapMng = class("MapManager")

---@class MapVO
local MapVO = {
    width = 0,
    height = 0
}

---@class GridState
MapMng.GridState = {
    Empty = 1,
    obstacle = 2,
    Occupy = 3,
    Order = 4 --将被占用的格子
}

MapMng.Const = {
    GridSize = 10, -- 格子边长(与Unity unit单位一致)
    PrintLog = false
}

---@param sess BattleSession
---@param vo MapVO
function MapMng:ctor(sess, vo)
    self.sess = sess
    self.vo = vo
    self:Init()
end

function MapMng:Init()
    Debug.Log("[MapManager]create map grid")
    -- create map grid mesh
    if not SystemConst.logicMode then
        CS.MapManager.Instance:LoadMap(self.vo.width, self.vo.height)
    end
    self.mapGrids = {}
    self.width = self.vo.width
    self.height = self.vo.height

    self.moveTasks = {}
    self.moveCache = {}
end

function MapMng:Update(delta)
    self:UpdateMoveTasks(delta)
    if not SystemConst.logicMode then
        for i = 1, #self.moveCache do
            CS.MapManager.Instance:UpdateUnit(self.moveCache[i].uid, self.moveCache[i].x, self.moveCache[i].z)
        end
    end
    self.moveCache = {}
end

-------------- map base function ------------

function MapMng:GetMapViewCenter()
    local center = {
        x = self.width * self.Const.GridSize / 2,
        z = self.height * self.Const.GridSize / 2
    }
    return center
end

--- x in [0,width-1] ; z in [0,height-1]

---@param x int pos-width
---@param z int pos-height
function MapMng:GetMapGridInfo(x, z)
    local index = z * self.width + x
    if self.mapGrids[index] == nil then
        self.mapGrids[index] = {
            state = self.GridState.Empty,
            unit = nil
        }
    end
    return self.mapGrids[index]
end
-- calculate the real dist(walk from A to B)
function MapMng:GetDist(pointA, pointB)
    local delX = math.abs(pointA.x - pointB.x)
    local delZ = math.abs(pointA.z - pointB.z)
    local diagLength = math.min(delX, delZ)
    return diagLength * Math.diagonalFactor + math.max(delX, delZ) - diagLength
end
-- calculate the range dist(caster from A to B)
function MapMng:GetRangeDist(pointA, pointB)
    local delX = math.abs(pointA.x - pointB.x)
    local delZ = math.abs(pointA.z - pointB.z)
    return math.max(delX, delZ)
end
---@param px int coord-x
---@param pz int coord-z
function MapMng:GetMapGridCenter(px, pz)
    return {
        x = px * MapMng.Const.GridSize + 0.5 * MapMng.Const.GridSize,
        z = pz * MapMng.Const.GridSize + 0.5 * MapMng.Const.GridSize
    }
end
---@param vx int view-x
---@param vz int view-z
function MapMng:GetMapGridByView(vx, vz)
    return {
        x = math.floor(vx / MapMng.Const.GridSize),
        z = math.floor(vz / MapMng.Const.GridSize)
    }
end

function MapMng:IsGridValid(x, z)
    return x >= 0 and x < self.width and z >= 0 and z < self.height
end

function MapMng:GetMoveTask(uid)
    if self.moveTasks[uid] ~= nil then
        return self.moveTasks[uid]
    end
    return nil
end

-- a* find a path of source->target, and return the next point in this path
---@param offset int 允许目的点距离target的偏离范围
function MapMng:AStar(source, target, offset)
    if offset == nil then
        offset = 1
    end
    local distCal = function(pos)
        return self:GetDist(pos, target)
    end
    local queue = {
        {
            x = source.x,
            z = source.z,
            cost = 0,
            dist = distCal(source),
            weight = distCal(source),
            parent = nil
        }
    }
    local closedMap = {}
    local matrix = {
        {x = -1, z = -1, cost = Math.diagonalFactor},
        {x = 1, z = 1, cost = Math.diagonalFactor},
        {x = -1, z = 1, cost = Math.diagonalFactor},
        {x = 1, z = -1, cost = Math.diagonalFactor},
        {x = 0, z = 1, cost = 1},
        {x = 0, z = -1, cost = 1},
        {x = -1, z = 0, cost = 1},
        {x = 1, z = 0, cost = 1}
    }
    local resultP
    while #queue > 0 do
        local curP = queue[1]
        local sx = curP.x
        local sz = curP.z
        -- if curP is near target-point then return this result
        if self:GetRangeDist(curP, target) <= offset then
            resultP = curP
            break
        end
        -- mark current point in closedMap
        closedMap[curP.x * 100 + curP.z] = true
        for i = 1, #matrix do
            local newP = {
                x = curP.x + matrix[i].x,
                z = curP.z + matrix[i].z
            }
            if
                self:IsGridValid(newP.x, newP.z) and closedMap[newP.x * 100 + newP.z] == nil and
                    self:GetMapGridInfo(newP.x, newP.z).state == self.GridState.Empty
             then
                -- this point is a new point
                local sameP =
                    table.find_if(
                    queue,
                    function(p)
                        return p.x == newP.x and p.z == newP.z
                    end
                )
                if sameP == nil then
                    newP.cost = curP.cost + matrix[i].cost
                    newP.dist = distCal(newP)
                    newP.weight = newP.cost + distCal(newP)
                    newP.parent = curP
                    table.insert(queue, newP)
                else
                    if sameP.weight > curP.cost + matrix[i].cost + distCal(newP) then
                        sameP.cost = curP.cost + matrix[i].cost
                        sameP.dist = distCal(newP)
                        sameP.weight = sameP.cost + sameP.dist
                        sameP.parent = curP
                    end
                end
            end
        end
        table.remove(queue, 1)
        table.sort(
            queue,
            function(a, b)
                return a.weight < b.weight
            end
        )
    end
    if MapMng.Const.PrintLog then
        local path = {}
        local cur = resultP
        while cur ~= nil do
            table.insert(path, 0, cur)
            cur = cur.parent
        end
        local str = tostring(uid) .. " path:"
        for i = 1, #path do
            str = str .. " [" .. path[i].x .. "," .. path[i].z .. "]=>"
        end
        Debug.Log(str)
    end

    if resultP == nil then
        --cannot find a path from source to target
        return nil
    else
        local nextP
        while resultP.parent ~= nil do
            nextP = resultP
            resultP = resultP.parent
        end
        return nextP
    end
end

-------------- map logic function------------

function MapMng:GetEmptyGrid(x, z)
    if self:IsGridValid(x, z) == false then
        Debug.Error("Attempt to find a invalid grid [x=", x, "] ", "[z=", z, "]")
        return nil, nil
    end
    if self:GetMapGridInfo(x, z).state == self.GridState.Empty then
        return x, z
    end
    -- start to find a adjacent emity grid
    local direction = {
        {x = 0, z = 1},
        {x = 1, z = 0},
        {x = 0, z = -1},
        {x = -1, z = 0}
    }

    local dirKey = 0
    local forward
    local nowPos = {x = x, z = z}
    local checkFunc = function(index)
        forward = direction[dirKey % 4 + 1]
        for i = 1, index do
            nowPos.x = nowPos.x + forward.x
            nowPos.z = nowPos.z + forward.z
            if
                self:IsGridValid(nowPos.x, nowPos.z) and
                    self:GetMapGridInfo(nowPos.x, nowPos.z).state == self.GridState.Empty
             then
                return nowPos.x, nowPos.z
            end
        end
        return nil, nil
    end
    for index = 1, self.width do
        local x, z
        x, z = checkFunc(index)
        if x ~= nil and z ~= nil then
            return x, z
        end
        dirKey = dirKey + 1
        x, z = checkFunc(index)
        if x ~= nil and z ~= nil then
            return x, z
        end
        dirKey = dirKey + 1
    end

    return nil, nil
end

function MapMng:TryCreateUnit(unit)
    local x, z = self:GetEmptyGrid(unit.vo.initPos.x, unit.vo.initPos.z)
    local gridInfo = self:GetMapGridInfo(x, z)
    gridInfo.state = self.GridState.Occupy
    gridInfo.unit = unit
    return x, z
end

function MapMng:TryRemoveUnit(unit)
    local pos = unit:GetPos()
    -- clear pos
    self:GetMapGridInfo(pos.x, pos.z).state = self.GridState.Empty
    self:GetMapGridInfo(pos.x, pos.z).unit = nil
    -- clear move task
    local task = self.moveTasks[unit.uid]
    if task ~= nil then
        self:GetMapGridInfo(task.goal.x, task.goal.z).state = self.GridState.Empty
        self.moveTasks[unit.uid] = nil
    end

    -- clear view
    if not SystemConst.logicMode then
        CS.MapManager.Instance:RemoveUnit(unit.uid, 2)
    end
end

function MapMng:UnitReqMove(unit, targetPos)
    local next = self:AStar(unit:GetPos(), targetPos)
    if next == nil then
        -- cannot move
        return false, next
    else
        self.moveTasks[unit.uid] = {
            goal = next,
            vgoal = self:GetMapGridCenter(next.x, next.z)
        }
        -- make Order
        local info = self:GetMapGridInfo(next.x, next.z)
        info.state = self.GridState.Order
        unit.moveCtrl:SwitchState("walking")
        return true, next
    end
end

function MapMng:UpdateUnitPos(unit)
    local nowPos = self:GetMapGridByView(unit.moveCtrl.viewPosition.x, unit.moveCtrl.viewPosition.z)
    table.insert(self.moveCache, {uid = unit.uid, x = unit.moveCtrl.viewPosition.x, z = unit.moveCtrl.viewPosition.z})
    if nowPos.x == unit.moveCtrl.position.x and nowPos.z == unit.moveCtrl.position.z then
        return
    end
    local info = self:GetMapGridInfo(unit.moveCtrl.position.x, unit.moveCtrl.position.z)
    info.state = MapMng.GridState.Empty
    info.unit = nil
    unit.moveCtrl.position = nowPos
    local newInfo = self:GetMapGridInfo(unit.moveCtrl.position.x, unit.moveCtrl.position.z)
    newInfo.state = MapMng.GridState.Occupy
    newInfo.unit = unit
    Debug.Log(unit.name .. " arrive new pos [" .. tostring(nowPos.x) .. "," .. tostring(nowPos.z) .. "]")
end

function MapMng:UpdateMoveTasks(delta)
    for uid, tb in pairs(self.moveTasks) do
        local unit = self.sess.field:FindUnit(uid)
        local nowPos = unit.moveCtrl.viewPosition
        local speed = unit.properties:GetProperty("speed")
        local advance = delta * speed
        local restDist =
            math.sqrt(
            ((tb.vgoal.x - nowPos.x) * (tb.vgoal.x - nowPos.x) + (tb.vgoal.z - nowPos.z) * (tb.vgoal.z - nowPos.z))
        )
        if restDist <= advance then
            -- has arrived goal
            unit.moveCtrl.viewPosition = self:GetMapGridCenter(tb.goal.x, tb.goal.z)
            self:UpdateUnitPos(unit)
            unit.moveCtrl:SwitchState("stop")
            self.moveTasks[uid] = nil
        else
            local forward = {
                x = (tb.vgoal.x - nowPos.x) / restDist,
                z = (tb.vgoal.z - nowPos.z) / restDist
            }
            unit.moveCtrl.viewPosition.x = nowPos.x + forward.x * advance
            unit.moveCtrl.viewPosition.z = nowPos.z + forward.z * advance
            self:UpdateUnitPos(unit)
        end
    end
end

return MapMng
