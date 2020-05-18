--[[
    author:yaxinge
    time:2020-05-16 19:47:17
]]
local this = {}
local BaseNode = require("GameLogics.Battle.Action.Nodes.BaseNode")

--CardExcuteType: 0:无指向 1:指向地面 2:指向单位 ...
--CardType: 0:英雄卡
this.Cards = {
    [1] = {ID = 1, CardExcuteType = 1, CardType = 0, CardName = "剑士"},
    [2] = {ID = 2, CardExcuteType = 1, CardType = 0, CardName = "弓手"}
}

this.CardSpells = {
    [1] = {
        {NodeType = BaseNode.NodeType.Summon, UnitId = 1}
    }
}

this.UnitPrefab = {
    --D:\Artifield\Assets\Resources\Battle\Character\Modles\SwordShield\Prefab
    [1] = "Battle/Character/Modles/SwordShield/Prefab/SwordShield",
}

return this
