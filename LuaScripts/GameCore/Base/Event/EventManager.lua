require("GameCore.Base.Event.Event")
---@class EventManager
local EventManager = class("EventManager")
local Event = require("GameCore.Base.Event.Event")

function EventManager:ctor()
    self._eventMap = {}
    self._handlers = {}
end
---@param eventName string
---@param handler Handle
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

function EventManager:StoreHandler(handler, func, obj)
    if self._handlers[func] == nil then
        self._handlers[func] = {}
    end
    if obj == nil then
        obj = "static"
    end
    self._handlers[func][obj] = handler
end

function EventManager:ClearHandler(func, obj)
    if func == nil then
        return
    end

    if obj == nil then
        obj = "static"
    end
    self._handlers[func][obj] = nil
end
---@param eventName string
---@param func function
---@param obj table
function EventManager:On(eventName, func, obj)
    ---@type Handle
    local handler = Handle:new(func, obj)
    self:StoreHandler(handler, func, obj)
    self:AddListener(eventName, handler)
    return handler
end

function EventManager:Off(eventName, func, obj)
    local handler = self._handlers[func][obj]
    if handler ~= nil then
        self:ClearHandler(func,obj)
        self:RemoveListener(eventName, handler)
    end
end

function EventManager:RegisterCS(eventName, func)
    local hfunc = function(table)
        func(table)
    end
    local handler = Handle:new(hfunc)
    self:AddListener(eventName, handler)
    return handler
end

function EventManager:UnRegisterCS(eventName, handler)
    self:RemoveListener(eventName, handler)
end

function EventManager:Emit(eventName, ...)
    if eventName == nil then
        return Debug.Error("[EventManager] try to emit event, but eventName is nil")
    end
    if self._eventMap[eventName] then
        self._eventMap[eventName]:Fire(...)
    end
end

return EventManager
