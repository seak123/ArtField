--[[
    author:yaxinge
    time:2020-05-02 23:38:55
]]
local EmbattleState = class("EmbattleState")

function EmbattleState:ctor(sess)
    self.sess = sess
    self.next = -1
end

function EmbattleState:Enter()
    --初始化布阵面板
    local obj = CS.WindowsUtil.AddWindow("Battle/Embattle/UI_EmbattlePanel", CS.UILayer.MainLayer_0)
    local instanceId = obj:GetInstanceID()
    local lb = __BehaviourManager:GetBehaviour(instanceId)
    if lb ~= nil then
        lb:SetData(self.sess.field.heroCards)
    end
end

function EmbattleState:Update()
end

return EmbattleState
