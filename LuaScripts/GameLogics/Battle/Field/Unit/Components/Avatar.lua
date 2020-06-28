---@class Avatar
local Avatar = class("Avatar")

Avatar.ActionType = {
    Idle = "Idle",
    Walk = "Walk",
    Attack = "Attack",
    Caster = "Caster",
    Die = "Die"
}

function Avatar:ctor(master)
    self.master = master
    if not SystemConst.logicMode then
        self:Init()
    end
end

function Avatar:Init()
    --- create avatar
    CS.LuaCallCSUtils.CreateUnit(
        self.master.uid,
        self.master.vo,
        self.master.moveCtrl.position.x,
        self.master.moveCtrl.position.z,
        function(avatar)
            self.avatar = avatar
        end
    )
    self.curState = Avatar.ActionType.Idle
    self:SwitchAction(Avatar.ActionType.Idle)
end

function Avatar:GetAnimator()
    if self.model then
        return self.model:GetComponent(CS.UnityEngine.Animator)
    end
    return nil
end

function Avatar:SwitchAction(type)
    if SystemConst.logicMode then
        return
    end

    if type == self.curState then
        -- replay current action
        if self.avatar ~= nil then
            self.avatar:PlayAnimation(type)
        end
    else
        -- switch to new action
        if self.avatar ~= nil then
            self.avatar:PlayAnimation(type)
        end
    end
end
---@param target Creature
function Avatar:TurnToTarget(target)
    if SystemConst.logicMode then
        return
    end
    self:TurnToPos(self.master.sess.map:GetMapGridCenter(target:GetPos().x, target:GetPos().z))
end
---@param pos viewPos
function Avatar:TurnToPos(pos)
    if SystemConst.logicMode then
        return
    end
    if self.avatar ~= nil then
        self.avatar:TurnToPos(pos.x, pos.z)
    end
end


return Avatar
