local EventConst = {}

-- BattleState
EventConst.ON_BEGIN_BATTLE = "ON_BEGIN_BATTLE" --游戏开始

EventConst.ON_ENTER_ACTION = "ON_ENTER_ACTION" --进入战斗

EventConst.ON_BATTLE_RESULT = "ON_BATTLE_RESULT" --战斗进入结算

-- Card
EventConst.ON_CARD_CHANGE = "ON_CARD_CHANGE"

-- Scheduler
EventConst.ON_SCHEDULER_UPDATE = "ON_SCHEDULER_UPDATE" --每帧更新调用

-- Notice
EventConst.ON_CREATE_NOTICE = "ON_CREATE_NOTICE"

return EventConst