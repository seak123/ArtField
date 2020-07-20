---@class ConfigManager
local ConfigManager = class("ConfigManager")
local CardConfig = require("GameLogics.Config.Battle.BattleConfig")

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

function ConfigManager:GetEffectConfig(effectId)
    return clone(CardConfig.Effects[effectId])
end

function ConfigManager:GetCardSpellConfig(spellId)
    return clone(CardConfig.CardSpells[spellId])
end

function ConfigManager:GetUnitConfig(unitId)
    return clone(CardConfig.UnitConfig[unitId])
end

function ConfigManager:GetSpellConfig(spellId)
    return clone(CardConfig.UnitSpells[spellId])
end

function ConfigManager:GetAIConfig(id)
    return clone(CardConfig.AIConfig[id])
end

function ConfigManager:GetLevelNum()
    return #require("GameLogics.Config.Battle.LevelConfig").levels
end

function ConfigManager:GetLevelConfig(id)
    return require("GameLogics.Config.Battle.LevelConfig").levels[id]
end

function ConfigManager:GetParadeConfig()
    return require("GameLogics.Config.Battle.LevelConfig").parade
end

return ConfigManager
