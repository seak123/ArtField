--[[
    author:yaxinge
    time:2020-05-16 19:47:17
]]
local this = {}
local BaseNode = require("GameLogics.Battle.Action.Nodes.BaseNode")

--CardExcuteType: 0:无指向 1:指向地面 2:指向单位 ...
--CardType: 0:英雄卡
this.Cards = {
    [1] = {id = 1, cardExcuteType = 1, cardType = 0, cardName = "剑士"},
    [2] = {id = 2, cardExcuteType = 1, cardType = 0, cardName = "弓手"}
}

this.CardSpells = {
    [1] = {
        {nodeType = BaseNode.NodeType.Summon, unitId = 1}
    },
    [99] = {
        {
            nodeType = BaseNode.NodeType.Summon,
            unitId = 1,
            childs = {{nodeType = BaseNode.NodeType.Summon}, {nodeType = BaseNode.NodeType.Summon}}
        }
    }
}


this.UnitPrefab = {
    --D:\Artifield\Assets\Resources\Battle\Character\Modles\SwordShield\Prefab
    [1] = "Battle/Character/Modles/SwordShield/Prefab/SwordShield"
}

this.UnitConfig = {
    [1] = {}
}

return this
