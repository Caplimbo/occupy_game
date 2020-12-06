local MonsterConfigs = {}

MonsterConfigs.monsterConfig = {}

MonsterConfigs.allMonsterNum = 2

attackList = {
    [1] = 10,
    [2] = 20,
}

defenseList = {
    [1] = 20,
    [2] = 10,
}

healthList = {
    [1] = 50,
    [2] = 100,
}

-- 标记种族
categoryList = {
    [1] = 1,
    [2] = 2,
}

modelNameList = {
    [1] = "mon1",
    [2] = "mon2",
}

-- initialize all monsterConfig
-- monster has attack, defense, ?health, model
for id=1, MonsterConfigs.allMonsterNum do
    MonsterConfigs.monsterConfig[id] = {attack = attackList[id], defense = defenseList[id], health = healthList[id],
                                     modelName = modelNameList[id], category = categoryList[id]}
end

return MonsterConfigs


