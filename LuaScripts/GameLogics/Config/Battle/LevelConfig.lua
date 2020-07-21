local this = {}
----------------------- example -----------------------------
-- map = {
--     width = 8,
--     height = 8
-- },
--单位id{1剑士2弓手3法师4刺客}
--x坐标[0,width),z坐标[0,height)
--camp阵营{1我方2敌方}
-- units = {
--     {unitId = 2, x = 5, z = 5, camp = 2},
--     {unitId = 1, x = 2, z = 2, camp = 2},
--     {unitId = 3, x = 4, z = 2, camp = 2},
--     {unitId = 4, x = 3, z = 7, camp = 2},
--     {unitId = 4, x = 0, z = 3, camp = 1}
-- },
--num 单位数量限制(不写为不设限)
--units 我方单位提供种类(不写为全开放)
--enemys 敌方单位提供种类(不写为全关闭)
-- conditions = {
--     num = 3,
--     units = {1, 2, 3},
--     enemys = {1, 2, 3}
-- }
---------------------------------------------------------------
-- 练习场配置
this.parade = {
    map = {
        width = 16,
        height = 16
    },
    units = {},
    conditions = {
        units = {1, 2, 3, 4},
        enemys = {1, 2, 3, 4}
    }
}
-- 关卡配置
this.levels = {
    --关卡1
    [1] = {
        map = {
            width = 8,
            height = 8
        },
        units = {
            {unitId = 1, x = 2, z = 4, camp = 2},
            {unitId = 1, x = 3, z = 4, camp = 2},
            {unitId = 1, x = 4, z = 4, camp = 2},
            {unitId = 1, x = 5, z = 4, camp = 2},
            {unitId = 1, x = 3, z = 5, camp = 2},
            {unitId = 1, x = 4, z = 5, camp = 2}
        },
        conditions = {
            num = 5
        }
    },
    [2] = {
        map = {
            width = 8,
            height = 8
        },
        units = {
            {unitId = 1, x = 2, z = 4, camp = 2},
            {unitId = 2, x = 3, z = 4, camp = 2},
            {unitId = 3, x = 4, z = 4, camp = 2},
            {unitId = 2, x = 5, z = 4, camp = 2},
            {unitId = 3, x = 3, z = 5, camp = 2},
            {unitId = 1, x = 4, z = 5, camp = 2}
        },
        conditions = {
            num = 5
        }
    }
}

return this
