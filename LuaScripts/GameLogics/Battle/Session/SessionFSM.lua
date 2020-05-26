---@class SessionFSM
local SessionFSM = class("SessionFSM")

SessionFSM.SessionType = {
    PreBattle = 0,
    Begin = 1,
    EmbattleHero = 2,
    Schedule = 3,
    PlayCard = 4,
    Action = 5,
    Final = 6
}

function SessionFSM:ctor(sess)
    self.fsm = {}
    self.sess = sess
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
    self.sess.state = key
    self.currState = self.fsm[key]
    self.currState:Enter()
end

function SessionFSM:Update(delta)
    if self.currState ~= nil then
        self.currState:Update(delta)
        if self.currState.next ~= -1 then
            Debug.Warn(
                "Switch State From " .. self.currState.__cname .. " to StateIndex" .. tostring(self.currState.next)
            )
            self:Switch2State(self.currState.next)
        end
    else
        Debug.Error("Session fsm : current state is nil")
    end
end

return SessionFSM
