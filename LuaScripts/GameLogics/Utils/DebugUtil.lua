local DebugUtil = {}
local UnityDebug = CS.UnityEngine.Debug

local function parseContent(...)
    local parseFuncSimple = function(msg)
        if type(msg) == "string" then
            return msg
        elseif type(msg) == "boolean" then
            return tostring(msg)
        elseif type(msg) == "number" then
            return tostring(msg)
        else
            return type(msg)
        end
    end
    local parseFunc = function(msg)
        if type(msg) == "string" then
            return msg
        elseif type(msg) == "boolean" then
            return tostring(msg)
        elseif type(msg) == "number" then
            return tostring(msg)
        elseif type(msg) == "table" then
            local str
            for k, v in pairs(msg) do
                if str == nil then
                    str = "{"
                else
                    str = str .. ", "
                end
                str = str .. "[" .. k .. "]" .. "=" .. parseFuncSimple(v)
            end
            str = str .. "}"
            return str
        else
            return type(msg)
        end
    end

    local args = {...}
    local res = ""
    for i, v in ipairs(args) do
        res = res .. parseFunc(args[i])
    end
    return res
end

function DebugUtil.Log(...)
    UnityDebug.Log(parseContent(...))
end

function DebugUtil.Warn(...)
    UnityDebug.LogWarning(parseContent(...))
end

function DebugUtil.Error(...)
    UnityDebug.LogError(parseContent(...))
end

return DebugUtil
