---@class LuaBehaviour
local LuaBehaviour = class("LuaBehaviour")
local UIUtil = require("GameCore.Base.Framework.LuaBehaviourUtil")

-- 示例setting写法
--[[
local setting = 
{    
    -- 普通的UI控件
    Elements = 
    {
        -- Element支持的参数:
        -- Name      GameObject的Path
        -- Alias     便利访问的名字, 有Count时，这是一个数组
        -- Count     一次绑定多个控件，从1开始
        -- Type      需要的MonoBehaviour类型, 不指定则绑定GameObject (访问element获取该type类)
        -- Script    需要绑定的lua脚本,赋值为脚本路径 (访问element获取该luabehaviour) 注意:Script参数与Type参数互斥
        -- Necessary 是否必须找到，Necessary = false时可以不报错
        -- Handler   回调函数
        -- Hide      是否默认隐藏掉

        {
            Name = "CloseButton",
            Type = CS.UnityEngine.UI.Button,
            Handler = 
            {
                onClick = "OnCloseButtonClick",
            }
        },
        -- 一次注册多个控件，自动通过数字下标去查找
        -- Item1, Item2, Item3
        {
            Name = "Item",
            Count = 3,
            Type = CS.UnityEngine.UI.Button,
            Handler = 
            {
                onClick = "OnCloseButtonClick",
            }
        },
    },

    -- 自动注册的Event消息
    Events =
    {
    	{
            Name: "OnEventName1",
            Handler: "OnEventExecute",
        }
	},

    -- 自动注册的Timer
    -- Timer Name 需要在全局保持唯一
    -- Timer = [$(duration),$(isAways)]
    Timers =
    {
        {
            Name = "SceneLoadedTimer",
            Timer = {1,true},
            Handler = "CheckSceneLoaded"
        }
    },
	}
}
]]
function LuaBehaviour:ctor(target, setting)
    self._target = target
    self._targetID = target:GetInstanceID()
    self._luaOperation = target:GetComponent(typeof(CS.LuaOperation))
    self._setting = setting
    --self._lambdaMap = {}
    self._events = {}

    UIUtil.BindElements(self)
end

-- 默认的一些消息/Events的注册
-- setting中没有需要就不注册
-- 同时，可以避免在子类中写super.OnStart等
function LuaBehaviour:CheckAndBindPrevEvents()
    local setting = self._setting
    local lo = self._luaOperation

    if setting.Behaviours ~= nil then
        lo:StartEvent(
            "+",
            function()
                UIUtil.BindBehaviours(self)
            end
        )
    end

    if setting.Layers ~= nil then
        UIUtil.BindLayers(self)
    end

    if setting.Events ~= nil or setting.StaticActions ~= nil or setting.Timers ~= nil then
        lo:EnableEvent(
            "+",
            function()
                UIUtil.BindEvents(self)
                UIUtil.BindTimers(self)
            end
        )

        lo:DisableEvent(
            "+",
            function()
                UIUtil.UnBindEvents(self)
                UIUtil.UnBindTimers(self)
            end
        )
    end
end

function LuaBehaviour:CheckAndBindLaterEvents()
    local lo = self._luaOperation

    -- local windowMediator, onWindowShowAnimEndFunc
    -- if self.OnWindowShowAnimEnd then
    --     windowMediator = self._target:GetComponent(typeof(CS.WindowMediator))
    --     if windowMediator then
    --         onWindowShowAnimEndFunc = function()
    --             self._visibleScope:ListenEvent(
    --                 "OnWindowShowAnimEnd_" .. tostring(self),
    --                 Timer:Once(0.001),
    --                 function()
    --                     self:OnWindowShowAnimEnd()
    --                 end
    --             )
    --         end

    --         windowMediator:ShowAnimEndEvent("+", onWindowShowAnimEndFunc)
    --     end
    -- end

    -- if self.OnVisible ~= nil then
    --     lo:StartEvent(
    --         "+",
    --         function()
    --             self:OnVisible()
    --             --__BehaviourManager:RegisterForVisibleEvent(self)

    --             self.__started = true
    --         end
    --     )

    --     lo:EnableEvent(
    --         "+",
    --         function()
    --             if self.__started == true then
    --                 __BehaviourManager:RegisterForVisibleEvent(self)
    --             end
    --         end
    --     )

    --     lo:DisableEvent(
    --         "+",
    --         function()
    --             if self.__started == true then
    --                 __BehaviourManager:UnregisterForVisibleEvent(self)

    --                 if windowMediator then
    --                     windowMediator:ShowAnimEndEvent("-", onWindowShowAnimEndFunc)
    --                 end
    --             end
    --         end
    --     )
    -- end

    --这个最后绑定
    lo:DestroyEvent(
        "+",
        function()
            BehaviourManager:DestroyBehaviour(self)
        end
    )
end

-- 可选的预定义事件回调
-- 如果需要监听，就写上对应的方法就好了

-- function LuaBehaviour:OnAwake()
-- 	-- print("OnAwake")
-- end

-- function LuaBehaviour:OnStart()
-- 	-- print("OnStart")
-- end

-- function LuaBehaviour:OnEnable()
-- 	-- print("OnEnable")
-- end

-- function LuaBehaviour:OnVisible()
--  -- print("OnVisible")
-- end

-- function LuaBehaviour:OnDisable()
-- 	-- print("OnDisable")
-- end

-- function LuaBehaviour:OnDestroy()
-- 	-- print("OnDestroy")
-- end

-- function LuaBehaviour:Invoke(handler, time)
--     --UIUtil.Invoke(self, handler, time)
-- end

-- function LuaBehaviour:StartCoroutine(func)
--     return __BehaviourManager._coroutineManager:StartCoroutine(self, func)
-- end

-- function LuaBehaviour:StopCoroutine(co)
--     __BehaviourManager._coroutineManager:StopCoroutine(self, co)
-- end

-- function LuaBehaviour:StopAllCoroutine()
--     __BehaviourManager._coroutineManager:StopAllCoroutines(self)
-- end

return LuaBehaviour
