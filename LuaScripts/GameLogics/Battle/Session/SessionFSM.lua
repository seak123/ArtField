---@class SessionFSM:class
local SessionFSM = class("SessionFSM")

SessionFSM.SessionType = {
    Begin = 0,
    EmbattleHero = 1,
    Schedule = 2,
    PlayCard = 3,
    Action = 4,
    Final = 5
}

function SessionFSM:ctor()
    self.fsm = {}
    self.currState = nil
end

function SessionFSM:RegisterState(key, state)
    self.fsm[key] = state
end

function SessionFSM:Switch2State(key)
    if self.currState ~= nil then
        self.currState:Leave()
    end
    CS.BattleManager.Instance:ChangeState(key)
    self.currState = self.fsm[key]
    self.currState:Enter()
end

function SessionFSM:Update(delta)
    if self.currState ~= nil then
        self.currState:Update(delta)
        if self.currState.next ~= -1 then
            Debug.Warn("Switch State From " .. self.currState.__cname .. " to StateIndex" .. tostring(self.currState.next))
            self:Switch2State(self.currState.next)
        end
    else
        Debug.Error("Session fsm : current state is nil")
    end
end

return SessionFSM
