local LuaBehaviourUtil = {}

local go_util = CS.GameObjectUtil

function LuaBehaviourUtil.FindGameObject(root_go, element_path, lb, necessary)
    if element_path == "." then
        return root_go
    else
        local go = go_util.FindGameObjectStrictly(root_go, element_path)
        if go == nil then
            if necessary == nil or necessary == true then
                Debug.Error("[" .. lb.__cname .. "]" .. "LuaBehaviour Setting seems incorrect, Can't Find GameObject " .. element_path .. " in Strictly mode, fix it")
            end
            go = go_util.FindGameObject(root_go, element_path)
        end

        return go
    end
end

function LuaBehaviourUtil.BindElement(lb, lb_go, element, field_name, is_array, element_path)
    local element_go = LuaBehaviourUtil.FindGameObject(lb_go, element_path, lb, element.Necessary)
    if element_go == nil then
        if element.Necessary == nil or element.Necessary == true then
            Debug.Error("[" .. lb.__cname .. "]" .. "LuaBehaviour Setting seems incorrect, Can't Find GameObject " .. element_path)
        end

        return
    end

    local obj = nil
    if element.Type then
        obj = element_go:GetComponent(typeof(element.Type))
        if not obj then
            Debug.Error("[" .. lb.__cname .. "]" .. "LuaBehaviour Setting seems incorrect, " .. tostring(field_name) .. " has no specific type")
            return
        end
    elseif element.Script then
        obj = element_go:AddComponent(typeof(CS.LuaOperation))
        obj:ResetClassPath(element.Script)
        obj = BehaviourManager:GetBehaviour(obj.gameObject:GetInstanceID())
    else
        obj = element_go
    end

    if is_array then
        table.insert(lb[field_name], obj)
    else
        lb[field_name] = obj
    end

    if element.Handler then
        local field = obj
        if not field then
            Debug.Error("[" .. lb.__cname .. "]" .. "LuaBehaviour Setting seems incorrect, Can't Find Field " .. tostring(field_name))
            return
        end

        for msg, rsp in pairs(element.Handler) do
            if not field[msg] then
                Debug.Error("[" .. lb.__cname .. "]" .. "LuaBehaviour Setting seems incorrect, Can't Find Function " .. msg)
            else
                local rsp_type = type(rsp)
                if rsp_type == "string" then
                    field[msg]:AddListener(
                        CS.EventDelegate.CreateVoidUnityAction(
                            function()
                                lb[rsp](lb)
                            end
                        )
                    )
                elseif rsp_type == "function" then
                    field[msg]:Add(CS.EventDelegate(rsp))
                end
            end
        end
    end

    if element.Hide then
        element_go:SetActive(false)
    end
end

function LuaBehaviourUtil.BindElements(lb)
    local lb_go = lb._target
    local elements = lb._setting.Elements

    -- if not lb_go then
    --     GameBooter.Error("Error to bind LuaBehaviour : " .. lb:class():name())
    --     return
    -- end

    if elements == nil then
        return
    end

    for i = 1, #elements do
        local element = elements[i]
        local field_name = element.Alias or element.Name

        if element.Count then
            lb[field_name] = {}
            for i = 1, element.Count do
                local elementName = element.NamePostfix and (element.Name .. i .. tostring(element.NamePostfix)) or (element.Name .. i)
                LuaBehaviourUtil.BindElement(lb, lb_go, element, field_name, true, elementName)
            end
        else
            LuaBehaviourUtil.BindElement(lb, lb_go, element, field_name, false, element.Name)
        end
    end
end

function LuaBehaviourUtil.BindEvents(lb)
    local events = lb._setting.Events

    if events == nil then
        return
    end

    for i = 1, #events do
        local info = events[i]
        local func = lb[info.Handler]
        EventManager:On(info.Name, func, lb)
        -- if func ~= nil then
        --     table.insert(lb._events, {name = info.Name, handler = EventManager:On(info.Name, func, lb)})
        -- end
    end
end

function LuaBehaviourUtil.UnBindEvents(lb)
    local events = lb._setting.Events

    if events == nil then
        return
    end

    for i, event in ipairs(events) do
        local info = events[i]
        local func = lb[info.Handler]
        EventManager:Off(info.Name, func, lb)
    end
end

function LuaBehaviourUtil.BindTimers(lb)
    local timers = lb._setting.Timers

    if timers == nil then
        return
    end

    for i = 1, #timers do
        local info = timers[i]

        local handler = lb[info.Handler]
        if handler ~= nil then
            Scheduler.timerSystem:Start(
                info.Name .. lb._target:GetInstanceID(),
                info.Timer[1],
                info.Timer[2],
                function()
                    handler(lb)
                end
            )
        end
    end
end

function LuaBehaviourUtil.UnBindTimers(lb)
    local timers = lb._setting.Timers

    if timers == nil then
        return
    end

    for i = 1, #timers do
        local info = timers[i]

        local handler = lb[info.Handler]
        if handler ~= nil then
            Scheduler.timerSystem:Close(info.Name .. lb._target:GetInstanceID())
        end
    end
end

return LuaBehaviourUtil
