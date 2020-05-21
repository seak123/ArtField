---@class TimerSystem
local TimerSystem = class("TimerSystem")

function TimerSystem:ctor()
    self.timerMap = {}
end

function TimerSystem:Start(timerName, duration, isAlways, callback)
    if self.timerMap[timerName] ~= nil then
        -- 已存在timer
        return
    end
    self.timerMap[timerName] = {
        duration = duration,
        elapsed = 0,
        isAlways = isAlways,
        callback = callback
    }
end

function TimerSystem:Close(timerName)
    self.timerMap[timerName] = nil
end

function TimerSystem:Update(delta)
    for k, v in pairs(self.timerMap) do
        v.elapsed = v.elapsed + delta
        if v.elapsed > v.duration then
            v.callback()
            if v.isAlways == true then
                v.elapsed = 0
            else
                self:Close(k)
            end
        end
    end
end

return TimerSystem
