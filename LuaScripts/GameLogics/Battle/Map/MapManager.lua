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
    GridSize = 5 -- 格子边长(与Unity unit单位一致)
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
            unit = nil,
        }
    end
    return self.mapGrids[index]
end


function MapMng:IsGridValid(x, z)
    return x >= 0 and x < self.width and z >= 0 and z < self.height
end

-------------- map logic function------------

function MapMng:GetEmptyGrid(x, z)
    if self:IsGridValid(x, z) == false then
        Debug.Error("Attempt to find a invalid grid [x=", x, "] ", "[z=", z, "]")
        return nil,nil
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
            if self:IsGridValid(nowPos.x, nowPos.z) and self:GetMapGridInfo(nowPos.x, nowPos.z).state == self.GridState.Empty then
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

    return nil,nil
end

function MapMng:TryCreateUnit(unit)
    local x,z = self:GetEmptyGrid(unit.vo.initPos.x,unit.vo.initPos.y)
    local gridInfo = self:GetMapGridInfo(x,z)
    gridInfo.state = self.GridState.Occupy
    gridInfo.unit = unit
    return x,z
end

function MapMng:UnitReqMove(unit,targetPos)
end

return MapMng
