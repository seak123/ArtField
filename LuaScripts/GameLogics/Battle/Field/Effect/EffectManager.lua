---@class EffectManager
local EffectMng = class("EffectManager")

function EffectMng:ctor(sess)
    self.sess = sess
    self.uid = 0
end

function EffectMng:CreateEffect(effectId,casterUid,targetUid)
    if SystemConst.logicMode then return nil end
    self.uid = self.uid + 1
    CS.EffectManager.Instance:CreateEffect(self.uid,casterUid,targetUid,effectId)
    return self.uid
end



return EffectMng