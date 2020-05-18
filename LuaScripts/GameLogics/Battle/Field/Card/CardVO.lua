--[[
    author:yaxinge
    time:2020-05-17 08:38:22
]]
local CardVO = class("cardVO")

CardVO.uid = 0
CardVO.Id = 0
CardVO.CardExcuteType = 0
CardVO.CardType = 0
CardVO.CardName = "None"

--[1] = {ID = 1, CardExcuteType = 1, CardType = 0, CardName = "剑士"},

function CardVO:ctor(rawData)
    self.Id = rawData.ID
    self.CardExcuteType = rawData.CardExcuteType
    self.CardType = rawData.CardType
    self.CardName = rawData.CardName
end

return CardVO
