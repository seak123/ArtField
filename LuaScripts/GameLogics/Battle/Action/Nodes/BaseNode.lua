--[[
    author:yaxinge
    time:2020-05-16 18:15:38
]]
---@class BaseNode
local BaseNode = class("BaseNode")

BaseNode.NodeType = {
    Summon = 1,
}

BaseNode.NodePath = {
    [1] = "GameLogics.Battle.Action.Nodes.Summon",
}

function BaseNode:ctor(  )
    
end

return BaseNode