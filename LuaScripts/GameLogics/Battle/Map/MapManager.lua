--[[
    author:yaxinge
    time:2020-04-27 22:24:13
]]
---@class MapManager
local MapMng = class("MapManager")

function MapMng:ctor(sess)
    self.sess = sess
    self:Init()
end

function MapMng:Init(  )
    Debug.Log("[MapManager]create map grid")
    -- create map grid mesh
    local i = CS.MapManager.Instance
    CS.MapManager.Instance:LoadMap(6,8);
end

return MapMng
