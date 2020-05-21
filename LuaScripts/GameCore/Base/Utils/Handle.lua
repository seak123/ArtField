---@class Handle
Handle = {}

-- 标识handle唯一Id
Handle.id = 1
-- 引用的函数
Handle.func = nil
-- 引用的对象
Handle.obj = nil

function Handle:new(func, obj)
    local handler = {}
    setmetatable(handler, self)
    self.__index = self

    handler.id = Handle.id
    Handle.id = Handle.id + 1

    handler.func = func
    handler.obj = obj

    return handler
end

function Handle:uid()
    return self.id
end

function Handle:run(...)
    if self.func ~= nil then
        if self.obj ~= nil then
            self.func(self.obj, ...)
        else
            self.func(...)
        end
    end
end
