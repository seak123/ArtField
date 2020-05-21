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
    cardVO.Id = cfg.ID
    cardVO.CardName = cfg.CardName
    cardVO.CardExcuteType = cfg.CardExcuteType
    cardVO.CardType = cfg.CardType

    return cardVO
end

function ConfigManager:GetSpellConfig(spellId)
    return CardConfig.CardSpells[spellId]
end

return ConfigManager
