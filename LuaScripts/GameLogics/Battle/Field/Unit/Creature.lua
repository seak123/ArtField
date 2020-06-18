---@class Creature
local Creature = class("Creature")
local Properties = require("GameLogics.Battle.Field.Unit.Components.Properties")
local Avatar = require("GameLogics.Battle.Field.Unit.Components.Avatar")
local Brain = require("GameLogics.Battle.Field.Unit.Components.ArtiBrain")
local MoveCtrl = require("GameLogics.Battle.Field.Unit.Components.MoveController")

function Creature:ctor(sess,unitVO)
    self.vo = unitVO
end

function Creature:Init()
    self.properties = Properties.new(self)
    self.avatar = Avatar.new(self)
    self.brain = Brain.new(self)
    self.moveCtrl = MoveCtrl.new(self)
end

function Creature:Update(delta)
    self.brain:Update(delta)
    self.moveCtrl:Update(delta)
end


function Creature:DoAttack(delta)
end

function Creature:UpdateAttackCoolDown(delta)
end

return Creature