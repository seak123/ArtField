--local LuaBehaviour = require("GameCore.Base.Framework.LuaBehaviour")
--local CoroutineManager = require 'Async.CoroutineManager'
---@class BehaviourManager
local BehaviourManager = class("BehaviourManager")

function BehaviourManager:ctor()
	self._behaviours = {}
	self._waitForVisibleBehaviours = {}

	--self._coroutineManager = CoroutineManager()
end

function BehaviourManager:CreateBehaviour(typename, go)
	local path = typename
	local Class = require(path)

	local lb = Class.new(go)
 
	self._behaviours[lb._targetID] = lb

	self:BindEvents(lb)

	return lb
end

function BehaviourManager:Update()
	for i,v in ipairs(self._waitForVisibleBehaviours) do
		if v ~= nil then
			local lb = v
			lb:OnVisible()
		end
	end

	self._waitForVisibleBehaviours = {}
end

function BehaviourManager:BindEvents(lb)
	local go = lb._target
	local lo = lb._luaOperation

	lb:CheckAndBindPrevEvents()
	
	local target_methods = { "OnAwake", "OnStart", "OnEnable", "OnDisable", "OnDestroy" }
	local events = { "AwakeEvent", "StartEvent", "EnableEvent", "DisableEvent", "DestroyEvent" }
  
	for i = 1, #target_methods do
		local func = lb[target_methods[i]]
		if func then
		  local event = lo[events[i]]
		  if event then
			  event(lo, '+', 
			    function()
				    func(lb)
			    end)
			end
		end
	end

	lb:CheckAndBindLaterEvents()
end

---@param id number GameObject的InstanceId
---@return LuaBehaviour
function BehaviourManager:GetBehaviour(id)
	return self._behaviours[id]
end

function BehaviourManager:DestroyBehaviour(lb)
	self._behaviours[lb._targetID] = nil
	-- print("Destroy frome LuaBehaviourManager: " .. lb._targetID)
end

function BehaviourManager:RegisterForVisibleEvent(lb)
	table.insert(self._waitForVisibleBehaviours, lb)
end

function BehaviourManager:UnregisterForVisibleEvent(lb)
	for i,v in ipairs(self._waitForVisibleBehaviours) do
		if v == lb then
			table.remove(self._waitForVisibleBehaviours, i)
			break
		end
	end
end
                          
function BehaviourManager:CleanBehaviourCache(typename)
	local klass = package.loaded[typename]
	if klass then
		local className = klass:name()
		_G.classic._registry[className] = nil -- NOTE : remove the check of duplicate class definition, be careful
		package.loaded[typename] = nil
	end
end

return BehaviourManager