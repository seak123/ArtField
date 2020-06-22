---@class ArtiBrain
local ArtiBrain = class("ArtiBrain")
local BT = require("GameLogics.Battle.AI.BehaviourTree")

function ArtiBrain:ctor(master)
    self.master = master
    self:Init()
end

function ArtiBrain:Init()
    self.tree = BT.new(self.master)
end

function ArtiBrain:Update(delta)
    self.tree:Execute(delta)
end

return ArtiBrain
