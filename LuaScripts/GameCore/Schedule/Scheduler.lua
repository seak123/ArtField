local Scheduler = {}
local EventConst = require("GameCore.Constant.EventConst")
local TimerSystem = require("GameCore.Schedule.TimerSystem")

function Scheduler.Init(  )
    Scheduler.timerSystem = TimerSystem:New()
end

function Scheduler.Update( delta )
    EventManager:Emit(EventConst.ON_SCHEDULER_UPDATE,delta)
    Scheduler.timerSystem:Update(delta)
end

return Scheduler