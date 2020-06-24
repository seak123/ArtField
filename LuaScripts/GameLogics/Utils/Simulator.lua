require("GameCore.Main.MainProcedure")
local socket = require("socket")

local beginTime = os.time()
local costTick = function()
    print("cost time: "..tostring( os.time() - beginTime).."s");
    beginTime = os.time()
end

Main()
BattleManager:StartBattle({id = 1, myHeros = {{1,2}, {1,2}}})

local function loadUnits(data)
    for i = 1, #data do
        local vo = ConfigManager:GetUnitConfig(data[i].unitId)
        vo.initPos = {
            x = data[i].x,
            z = data[i].z
        }
        BattleManager.session.field:CreateUnit(vo, data[i].camp)
    end
end

local testData = {
    {unitId = 1, x = 0, z = 0, camp = 1},
    {unitId = 2, x = 5, z = 5, camp = 2},
    {unitId = 1, x = 0, z = 1, camp = 1},
    {unitId = 1, x = 2, z = 2, camp = 2},
}

loadUnits(testData)
BattleManager.session.fsm:Switch2State(require("GameLogics.Battle.Session.SessionFSM").SessionType.Action)

--costTick()
while BattleManager.session ~= nil do
    MainUpdate(0.003)
    --costTick()
end