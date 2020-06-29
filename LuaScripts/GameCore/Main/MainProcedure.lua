require("GameCore.Base.Utils.Functions")
require("GameCore.Base.Utils.Handle")
require("GameCore.Base.Utils.List")

_G.Math = require("GameCore.Base.Utils.MathUtil")
_G.Debug = require("GameLogics.Utils.DebugUtil")
_G.SystemConst = require("GameCore.Constant.SystemConst")

_G.BehaviourManager = require("GameCore.Base.Framework.BehaviourManager").new()
_G.EventManager = require("GameCore.Base.Event.EventManager").new()
_G.ConfigManager = require("GameCore.Base.Config.ConfigManager").new()

function Main()
    _G.NoticeManager = require("GameLogics.UI.NoticeSystem.NoticeManager")
    _G.Scheduler = require("GameCore.Schedule.Scheduler")
    _G.BattleManager = require("GameLogics.Battle.BattleManager")
    Scheduler.Init()
    _G.MainUIManager = require("GameLogics.UI.MainUIManager")
    if not SystemConst.logicMode then
        CS.WindowsUtil.AddWindow("MainUI", CS.UILayer.MainLayer_0)
    end
end

function MainUpdate(delta)
    Scheduler.Update(delta)
end
