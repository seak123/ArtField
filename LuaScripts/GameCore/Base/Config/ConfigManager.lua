---@class ConfigManager
local ConfigManager = class("ConfigManager")
local CardConfig = require("GameLogics.Config.Battle.CardConfig")

function ConfigManager:ctor()
end
---@param cardId number 卡牌id
---@return CardVO
function ConfigManager:GetCardConfig(cardId)
    ---@type CardVO
    local cardVO = {}
    local cfg = CardConfig.Cards[cardId]
    cardVO.id = cfg.id
    cardVO.cardName = cfg.cardName
    cardVO.cardExcuteType = cfg.cardExcuteType
    cardVO.cardType = cfg.cardType

    return cardVO
end

function ConfigManager:GetSpellConfig(spellId)
    return CardConfig.CardSpells[spellId]
end

function ConfigManager:GetUnitConfig(unitId)
    return CardConfig.UnitConfig[unitId]
end

return ConfigManager
