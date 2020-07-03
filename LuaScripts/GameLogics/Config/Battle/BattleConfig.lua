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
--卡牌基础信息
this.Cards = {
    [1] = {id = 1, cardExcuteType = 1, cardType = 0, cardName = "剑士"},
    [2] = {id = 2, cardExcuteType = 1, cardType = 0, cardName = "弓手"},
    [3] = {id = 3, cardExcuteType = 1, cardType = 0, cardName = "法师"},
    [4] = {id = 4, cardExcuteType = 1, cardType = 0, cardName = "刺客"}
}
--- 特效配置
this.Effects = {
    [1] = {
        path = "Effects/BowShoot",
        socket = "S_Attack"
    }
}
--- 卡片效果配置
this.CardSpells = {
    [1] = SpawnHero.new(1),
    [2] = SpawnHero.new(2),
    [3] = SpawnHero.new(3),
    [4] = SpawnHero.new(4)
}

this.UnitSpells = {
    [1] = {path = "GameLogics.Config.Spell.Unit.ShadowPassive"}
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
--- 单位基础配置
this.UnitConfig = {
    --D:\Artifield\Assets\Resources\Battle\Character\Modles\SwordShield\Prefab
    [1] = {
        id = 1,
        name = "剑士",
        speed = 8.5,
        hp = 80,
        attack = 6,
        attackTime = 1.6, -- 攻击间隔
        attackAnim = 0.1, -- 攻击前摇占比
        attackRange = 1, -- 攻击范围
        rage = 50, --怒气上限
        isRange = 0, --是否远程
        prefabPath = "Battle/Character/Modles/SwordShield/Prefab/SwordShield", --模型路径
        AI = 1 -- AI
    },
    [2] = {
        id = 2,
        name = "弓手",
        speed = 6.5,
        hp = 55,
        attack = 8,
        attackTime = 1.3,
        attackAnim = 0.6,
        attackRange = 6,
        rage = 50,
        isRange = 1,
        prefabPath = "Battle/Character/Modles/Bow/Prefab/Bow",
        AI = 2,
        projectileSpeed = 60, -- 弹道速度
        projectileASpeed = 50, -- 弹道加速度
        projectileId = 1 -- 弹道特效id
    },
    [3] = {
        id = 3,
        name = "法师",
        speed = 5.5,
        hp = 45,
        attack = 16,
        attackTime = 2.2,
        attackAnim = 0.2,
        attackRange = 4,
        rage = 50,
        isRange = 1,
        prefabPath = "Battle/Character/Modles/Wizard/Prefab/Wizard",
        AI = 1,
        projectileSpeed = 30, -- 弹道速度
        projectileASpeed = 80, -- 弹道加速度
        projectileId = 1 -- 弹道特效id
    },
    [4] = {
        id = 4,
        name = "刺客",
        speed = 12.5,
        hp = 45,
        attack = 6,
        attackTime = 0.9, -- 攻击间隔
        attackAnim = 0.05, -- 攻击前摇占比
        attackRange = 1, -- 攻击范围
        rage = 50, --怒气上限
        isRange = 0, --是否远程
        prefabPath = "Battle/Character/Modles/Shadow/Prefab/Shadow", --模型路径
        AI = 3, -- AI
        passiveSp = {1} -- 被动技能
    }
}
--- AI 配置
this.AIConfig = {
    --- 基础AI
    [1] = {
        root = {
            feature = "Selector",
            type = "Single",
            vo = {
                selectType = "Default"
            },
            actions = {
                {
                    feature = "Action",
                    type = "Static",
                    decorators = {
                        {
                            feature = "Decorator",
                            type = "SeekTarget",
                            vo = {
                                seekType = "NearestEnemy"
                            }
                        }
                    },
                    vo = {}
                },
                {
                    feature = "Selector",
                    type = "Single",
                    vo = {
                        selectType = "Default"
                    },
                    actions = {
                        {
                            feature = "Action",
                            type = "Attack",
                            decorators = {
                                {
                                    feature = "Decorator",
                                    type = "SeekTarget",
                                    vo = {
                                        seekType = "NearestEnemy"
                                    }
                                },
                                vo = {}
                            }
                        },
                        {
                            feature = "Action",
                            type = "Wait",
                            decorators = {
                                {
                                    feature = "Decorator",
                                    type = "SeekTarget",
                                    vo = {
                                        seekType = "NearestEnemy"
                                    }
                                },
                                vo = {}
                            },
                            vo = {
                                waitType = "Enemy"
                            }
                        }
                    }
                },
                {
                    feature = "Action",
                    type = "Move",
                    decorators = {
                        {
                            feature = "Decorator",
                            type = "SeekTarget",
                            vo = {
                                seekType = "NearestEnemy"
                            }
                        }
                    },
                    vo = {}
                }
            }
        }
    },
    [2] = {
        root = {
            feature = "Selector",
            type = "Single",
            vo = {
                selectType = "Default"
            },
            actions = {
                {
                    feature = "Action",
                    type = "Static",
                    decorators = {
                        {
                            feature = "Decorator",
                            type = "SeekTarget",
                            vo = {
                                seekType = "FarthestEnemy"
                            }
                        }
                    },
                    vo = {}
                },
                {
                    feature = "Selector",
                    type = "Single",
                    vo = {
                        selectType = "Default"
                    },
                    actions = {
                        {
                            feature = "Action",
                            type = "Attack",
                            decorators = {
                                {
                                    feature = "Decorator",
                                    type = "SeekTarget",
                                    vo = {
                                        seekType = "FarthestEnemy"
                                    }
                                },
                                vo = {}
                            }
                        },
                        {
                            feature = "Action",
                            type = "Wait",
                            decorators = {
                                {
                                    feature = "Decorator",
                                    type = "SeekTarget",
                                    vo = {
                                        seekType = "FarthestEnemy"
                                    }
                                },
                                vo = {}
                            },
                            vo = {
                                waitType = "Enemy"
                            }
                        }
                    }
                },
                {
                    feature = "Action",
                    type = "Move",
                    decorators = {
                        {
                            feature = "Decorator",
                            type = "SeekTarget",
                            vo = {
                                seekType = "FarthestEnemy"
                            }
                        }
                    },
                    vo = {}
                }
            }
        }
    },
    --- 弓手AI
    -- [2] = {
    --     root = {
    --         feature = "Selector",
    --         type = "Single",
    --         vo = {
    --             selectType = "Default"
    --         },
    --         actions = {
    --             {
    --                 feature = "Action",
    --                 type = "Static",
    --                 decorators = {
    --                     {
    --                         feature = "Decorator",
    --                         type = "SeekTarget",
    --                         vo = {
    --                             seekType = "NearestEnemy"
    --                         }
    --                     }
    --                 },
    --                 vo = {}
    --             },
    --             {
    --                 feature = "Selector",
    --                 type = "Single",
    --                 vo = {
    --                     selectType = "Default"
    --                 },
    --                 actions = {
    --                     {
    --                         feature = "Action",
    --                         type = "Attack",
    --                         decorators = {
    --                             {
    --                                 feature = "Decorator",
    --                                 type = "SeekTarget",
    --                                 vo = {
    --                                     seekType = "NearestEnemy"
    --                                 }
    --                             },
    --                             {
    --                                 feature = "Decorator",
    --                                 type = "AroundUnits",
    --                                 vo = {
    --                                     findType = "Enemy",
    --                                     aroundRange = 1,
    --                                     maxCount = 0
    --                                 }
    --                             }
    --                         },
    --                         interpDecorators = {
    --                             {
    --                                 feature = "Decorator",
    --                                 type = "AroundUnits",
    --                                 vo = {
    --                                     findType = "Enemy",
    --                                     aroundRange = 1,
    --                                     minCount = 1
    --                                 }
    --                             }
    --                         },
    --                         vo = {}
    --                     },
    --                     {
    --                         feature = "Action",
    --                         type = "Attack",
    --                         decorators = {
    --                             {
    --                                 feature = "Decorator",
    --                                 type = "SeekTarget",
    --                                 vo = {
    --                                     seekType = "FarthestEnemy"
    --                                 }
    --                             },
    --                             {
    --                                 feature = "Decorator",
    --                                 type = "AroundUnits",
    --                                 vo = {
    --                                     findType = "Enemy",
    --                                     aroundRange = 1,
    --                                     minCount = 1
    --                                 }
    --                             }
    --                         },
    --                         interpDecorators = {
    --                             {
    --                                 feature = "Decorator",
    --                                 type = "AroundUnits",
    --                                 vo = {
    --                                     findType = "Enemy",
    --                                     aroundRange = 1,
    --                                     maxCount = 0
    --                                 }
    --                             }
    --                         },
    --                         vo = {}
    --                     },
    --                     {
    --                         feature = "Action",
    --                         type = "Wait",
    --                         decorators = {
    --                             {
    --                                 feature = "Decorator",
    --                                 type = "SeekTarget",
    --                                 vo = {
    --                                     seekType = "FarthestEnemy"
    --                                 }
    --                             },
    --                             vo = {}
    --                         },
    --                         vo = {
    --                             waitType = "Enemy"
    --                         }
    --                     }
    --                 }
    --             },
    --             {
    --                 feature = "Action",
    --                 type = "Move",
    --                 decorators = {
    --                     {
    --                         feature = "Decorator",
    --                         type = "SeekTarget",
    --                         vo = {
    --                             seekType = "FarthestEnemy"
    --                         }
    --                     }
    --                 },
    --                 vo = {}
    --             }
    --         }
    --     }
    -- },
    -- 刺客AI
    [3] = {
        root = {
            feature = "Selector",
            type = "Single",
            vo = {
                selectType = "Default"
            },
            actions = {
                {
                    feature = "Action",
                    type = "Static",
                    decorators = {
                        {
                            feature = "Decorator",
                            type = "SeekTarget",
                            vo = {
                                seekType = "NearestEnemy"
                            }
                        }
                    },
                    vo = {
                        delay = 2
                    }
                },
                {
                    feature = "Selector",
                    type = "Single",
                    vo = {
                        selectType = "Default"
                    },
                    actions = {
                        {
                            feature = "Action",
                            type = "Attack",
                            decorators = {
                                {
                                    feature = "Decorator",
                                    type = "SeekTarget",
                                    vo = {
                                        seekType = "NearestEnemy"
                                    }
                                },
                                vo = {}
                            }
                        },
                        {
                            feature = "Action",
                            type = "Wait",
                            decorators = {
                                {
                                    feature = "Decorator",
                                    type = "SeekTarget",
                                    vo = {
                                        seekType = "NearestEnemy"
                                    }
                                },
                                vo = {}
                            },
                            vo = {
                                waitType = "Enemy"
                            }
                        }
                    }
                },
                {
                    feature = "Action",
                    type = "Move",
                    decorators = {
                        {
                            feature = "Decorator",
                            type = "SeekTarget",
                            vo = {
                                seekType = "NearestEnemy"
                            }
                        }
                    },
                    vo = {}
                }
            }
        }
    }
}

return this
