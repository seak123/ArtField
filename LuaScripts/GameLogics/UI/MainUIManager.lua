--[[
    author:yaxinge
    time:2020-03-15 19:25:40
]]
local MainUIMng = {}

MainUIMng.mainUI = nil

function MainUIMng:Hide(  )
    MainUIMng.mainUI._target:SetActive(false)
end

return MainUIMng