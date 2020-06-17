--[[
    author:yaxinge
    time:2020-05-16 18:33:23
]]
---@class Creature
local Creature = class("Createure")
local Properties = require("GameLogics.Battle.Field.Unit.Components.Properties")

function Creature:ctor(sess,unitVO)
    self.vo = unitVO
end

function Creature:Init()
    self.properties = Properties.new(self)
end


function Creature:NoramlAttack()
end

return Creature