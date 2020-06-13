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
    Occupy = 3,
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

---@param x int pos-width
---@param z int pos-height
function MapMng:GetMapGridInfo(x, z)
    local index = z * self.width + x
    if self.mapGrids[index] == nil then
        self.mapGrids[index] = {
            state = self.GridState.Empty,
        }
    end
    return self.mapGrids[index]
end

function MapMng:TryMoveUnit()
end

return MapMng
