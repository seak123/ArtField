--[[
    author:yaxinge
    time:2020-04-27 22:24:13
]]
---@class MapManager
local MapMng = class("MapManager")

---@param sess BattleSession
---@return MapManager
function MapMng:New(sess)
    return self.new(sess)
end

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
