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
    if not SystemConst.logicMode then
        self:Init()
    end
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
    if SystemConst.logicMode then
        return
    end
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
---@param target Creature
function Avatar:TurnToTarget(target)
    if SystemConst.logicMode then
        return
    end
end
---@param pos viewPos
function Avatar:TurnToPos(pos)
    if SystemConst.logicMode then
        return
    end
end

return Avatar
