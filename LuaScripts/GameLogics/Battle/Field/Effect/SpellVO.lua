---@class SpellVO
local SpellVO = class("SpellVO")

--技能特征定义
SpellVO.SpellBehavior = {
    Passive = 2 ^ 0, --被动技能
    Channel = 2 ^ 1, --需要持续施法
    Projectile = 2 ^ 2, --具有技能弹道
    Command = 2 ^ 3, --命令式技能(卡牌施法)
    Immediate = 2 ^ 4 --立即执行
}

--技能事件定义
SpellVO.SpellEvents = {
    OnSpellStart = "OnSpellStart", --技能施法开始
    OnChannelFinish = "OnChannelFinish", --技能持续施法结束
    OnChannelInterrupted = "OnChannelInterrupted", --技能持续施法被打断
    OnChannelSucceed = "OnChannelSucceed", --技能持续施法成功
    OnProjectileFinish = "OnProjectileFinish", --技能弹道结束
    OnProjectileHitUnit = "OnProjectileHitUnit", --技能弹道击中单位
    OnOwnerSpawned = "OnOwnerSpawned", --技能拥有者出生
    OnOwnerDied = "OnOwnerDied" --技能拥有者死亡
}

---@field behavior 技能特征
SpellVO.behavior = 0
---@field projectileId 技能弹道的特效id
SpellVO.projectileId = 0
---@field projectileSpeed 技能弹道的速度
SpellVO.projectileSpeed = 0
---@field projectileAspeed 技能弹道的加速度
SpellVO.projectileASpeed = 0
---@field events 技能事件
SpellVO.events = {}

function SpellVO:ctor()
end

function SpellVO.hasBehaviour(behavior, needBehaviour)
    return Math.bitAND(behavior, needBehaviour) > 0
end

function SpellVO.param(name)
    return function(target)
        return target:GetProperties(name)
    end
end

return SpellVO
