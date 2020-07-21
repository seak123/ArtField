local NoticeMng = {}
local EventConst = require("GameCore.Constant.EventConst")

NoticeMng.INIT_POS_Y = -100
NoticeMng.NOTIC_HEIGHT = 30

function NoticeMng.Notice(content)
    if SystemConst.logicMode then
        return
    end
    EventManager:Emit(EventConst.ON_CREATE_NOTICE)
    local lb = NoticeMng.FetchLb()
    lb:SetNotice(content)
end

---@return UI_Notice
function NoticeMng.FetchLb()
    local obj = CS.WindowsUtil.AddWindow("Common/UI_Notice")
    return BehaviourManager:GetBehaviour(obj:GetInstanceID())
end

return NoticeMng
