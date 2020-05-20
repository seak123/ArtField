---@class ConfigManager
local ConfigManager = class("ConfigManager")
local CardConfig = require("GameLogics.Config.Battle.CardConfig")

---@return ConfigManager
function ConfigManager:New()
    return self.new()
end

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

return ConfigManager
