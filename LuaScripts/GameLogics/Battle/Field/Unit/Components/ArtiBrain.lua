---@class ArtiBrain
local ArtiBrain = class("ArtiBrain")

function ArtiBrain:ctor(master)
    self.master = master
    self:Init()
end

function ArtiBrain:Init()
end

function ArtiBrain:Update(delta)
end

return ArtiBrain
