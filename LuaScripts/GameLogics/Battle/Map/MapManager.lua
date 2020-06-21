--[[
    author:yaxinge
    time:2020-04-27 22:24:13
]]
---@class MapManager
local MapMng = class("MapManager")

---@class MapVO
local MapVO = {
    width = 6,
    height = 8
}

---@class GridState
MapMng.GridState = {
    Empty = 1,
    obstacle = 2,
    Occupy = 3
}

MapMng.Const = {
    GridSize = 10 -- 格子边长(与Unity unit单位一致)
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
    CS.MapManager.Instance:LoadMap(self.vo.width, self.vo.height)
    self.mapGrids = {}
    self.width = self.vo.width
    self.height = self.vo.height

    self.moveTasks = {}
end

function MapMng:Update(delta)
    self:UpdateMoveTasks(delta)
end

-------------- map base function ------------

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

-- a* find a path of source->target, and return the next point in this path
function MapMng:AStar(source, target)
    local distCal = function(pos)
        local delX = math.abs(pos.x - target.x)
        local delZ = math.abs(pos.z - target.z)
        local diagLength = math.min(delX, delZ)
        return diagLength * Math.diagonalFactor + math.max(delX, delZ) - diagLength
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
        -- if curP is target-point then return this result
        if curP.x == target.x and curP.z == target.z then
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
                    table.insert(
                        queue,
                        {
                            x = newP.x,
                            z = newP.z,
                            cost = curP.cost + matrix[i].cost,
                            dist = distCal(newP),
                            weight = matrix[i].cost + distCal(newP),
                            parent = curP
                        }
                    )
                else
                    if sameP.weight > matrix[i].cost + distCal(newP) then
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
                return a.weight - b.weight
            end
        )
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
        forward = direction[dirKey % 4]
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
    local x, z = self:GetEmptyGrid(unit.vo.initPos.x, unit.vo.initPos.y)
    local gridInfo = self:GetMapGridInfo(x, z)
    gridInfo.state = self.GridState.Occupy
    gridInfo.unit = unit
    return x, z
end

function MapMng:UnitReqMove(unit, targetPos)
    local next = self:AStar(unit:GetPos(), targetPos)
    if next == nil then
        -- cannot move
        return false
    else
        self.moveTasks[unit.uid] = {
            goal = next,
            vgoal = self:GetMapGridInfo(next.x, next.z)
        }
        unit.moveCtrl.moving = true
        return true
    end
end

function MapMng:UpdateUnitPos(unit)
    local info = self:GetMapGridInfo(unit.moveCtrl.position.x, unit.moveCtrl.position.z)
    info.state = MapMng.GridState.Empty
    info.unit = nil
    local nowPos = self:GetMapGridByView(unit.moveCtrl.viewPosition.x, unit.moveCtrl.viewPosition.z)
    unit.moveCtrl.position = nowPos
    local newInfo = self:GetMapGridInfo(unit.moveCtrl.position.x, unit.moveCtrl.position.z)
    newInfo.state = MapMng.GridState.Occupy
    newInfo.unit = unit
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
            unit.moveCtrl.moving = false
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
