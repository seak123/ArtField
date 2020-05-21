---@class Event
local Event = class("Event")

function Event:ctor(name)
    self.name = name
    self.responsers = list:new()
end
---@param handler Handle
function Event:Bind(handler)
    if handler == nil then
        return
    end
    -- 判断是否已存在
    for v in ilist(self.responsers) do
        if v == handler then
            Debug.Log(string.format("事件[%s]重复,已存在相同responser", self.name))
            return
        end
    end
    self.responsers:push(handler)
end
---@param handler Handle
function Event:UnBind(handler)
    if handler == nil then
        return
    end
    for v, itr in rilist(self.responsers) do
        if v ~= nil and v:uid() == handler:uid() then
            self.responsers:erase(itr)
            return
        end
    end
end

function Event:Fire(...)
    for v in ilist(self.responsers) do
        v:run(...)
    end
end

return Event
