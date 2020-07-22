local MessageMng = {}
local EventConst = require("GameCore.Constant.EventConst")

MessageMng.BoxType = {
    Confirm = 0,
    Input = 1
}

MessageMng.Prefabs = {
    [MessageMng.BoxType.Confirm] = "Common/UI_MessageConfirmBox",
    [MessageMng.BoxType.Input] = "Common/UI_MessageInputBox"
}

function MessageMng.ShowMessageBox(boxType, content, callback)
    if SystemConst.logicMode then
        return
    end
    local lb = MessageMng.FetchLb(boxType)
    lb:SetText(content)
    lb:SetCallBack(callback)
end

---@return UI_Notice
function MessageMng.FetchLb(boxType)
    local obj = CS.WindowsUtil.AddWindow(MessageMng.Prefabs[boxType])
    return BehaviourManager:GetBehaviour(obj:GetInstanceID())
end

return MessageMng
