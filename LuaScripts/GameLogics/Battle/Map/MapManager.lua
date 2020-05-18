--[[
    author:yaxinge
    time:2020-04-27 22:24:13
]]
local MapMng = class("MapManager")

function MapMng:ctor(sess)
    self.sess = sess
    self:Init()
end

function MapMng:Init(  )
    Debug.Log("[MapManager]create map grid")
    -- create map grid mesh
    CS.MapManager.Instance:LoadMap(6,8);
end

return MapMng
