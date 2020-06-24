
local this = {}
local SpawnHero = require("GameLogics.Config.Spell.Card.SpawnHero")

---@class CardVO
local CardVO = {
    uid = 0,
    id = 0,
    cardExcuteType = 0,
    cardType = 0,
    cardName = "None"
}
--CardExcuteType: 0:无指向 1:指向地面 2:指向单位 ...
--CardType: 0:英雄卡
this.Cards = {
    [1] = {id = 1, cardExcuteType = 1, cardType = 0, cardName = "剑士"},
    [2] = {id = 2, cardExcuteType = 1, cardType = 0, cardName = "弓手"}
}

this.CardSpells = {
    [1] = SpawnHero.new(1),
}
---@class UnitVO
local UnitVO = {
    id = 0,
    speed = 0,
    hp = 0,
    attack = 0,
    attackRange = 0,
    mobility = 0,
    prefabPath = ""
}
this.UnitConfig = {
    --D:\Artifield\Assets\Resources\Battle\Character\Modles\SwordShield\Prefab
    [1] = {
        id = 1,
        name = "剑士",
        speed = 6,
        hp = 80,
        attack = 6,
        attackTime = 1.8,
        attackAnim = 0.1,
        attackRange = 1,
        rage = 50,
        isRange = 0,
        prefabPath = "Battle/Character/Modles/SwordShield/Prefab/SwordShield"
    },
    [2] = {
        id = 1,
        name = "弓手",
        speed = 4,
        hp = 55,
        attack = 10,
        attackTime = 1,
        attackAnim = 0.1,
        attackRange = 3,
        rage = 50,
        isRange = 1,
        prefabPath = "Battle/Character/Modles/SwordShield/Prefab/SwordShield"
    }
}

return this
