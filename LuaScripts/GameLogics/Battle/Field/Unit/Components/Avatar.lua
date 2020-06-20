---@class Avatar
local Avatar = class("Avatar")

Avatar.ActionType = {
    Idle = 0,
    Walk = 1,
    Attack = 2,
    Caster = 3,
    Die = 4
}

function Avatar:ctor(master)
    self.master = master
    self:Init()
end

function Avatar:Init()
    --- create avatar
    self.model =
        CS.LuaCallCSUtils.CreateUnit(
        self.master.uid,
        self.master.vo,
        self.master.moveCtrl.position.x,
        self.master.moveCtrl.position.z
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
    local animator = self:GetAnimator()
    if nil == animator then
        return
    end

    if type == self.curState then
        -- replay current action
    else
        -- switch to new action
    end
end

function Avatar:TurnToTarget(target)
end

function Avatar:TurnToPos(pos)
end

return Avatar
