require("GameCore.Base.Event.Event")

local EventManager = class("EventManager")
local Event = require("GameCore.Base.Event.Event")

function EventManager:ctor(  )
    self._eventMap = {}
end

function EventManager:AddListener(eventName, handler)
    if self._eventMap[eventName] == nil then
        self._eventMap[eventName] = {}
        self._eventMap[eventName] = Event.new(eventName)
    end
    self._eventMap[eventName]:Bind(handler)
end

function EventManager:RemoveListener(eventName, handler)
    if self._eventMap[eventName] ~= nil then
        self._eventMap[eventName]:UnBind(handler)
    end
end

function EventManager:On(eventName, func, obj)
    local handler = Handle:new(func, obj)
    self:AddListener(eventName, handler)
    return handler
end

function EventManager:Off(eventName, handler)
    self:RemoveListener(eventName, handler)
end

function EventManager:Emit(eventName, ...)
    if self._eventMap[eventName] then
        self._eventMap[eventName]:Fire(...)
    end
end

return EventManager
