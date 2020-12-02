local AllMonsterModule = {}

AllMonsterModule.monsters = {}

monsterNum = 2

attackList = {
    [1] = 10,
    [2] = 20,
}

defenseList = {
    [1] = 20,
    [2] = 10,
}

modelNameList = {
    [1] = "mon1",
    [2] = "mon2",
}

-- initialize all monsters
-- monster has attack, defense, ?health, model
for id=1, #attackList do
    AllMonsterModule.monsters[id] = {attack = attackList[id], defense = defenseList[id],
                                     modelName = modelNameList[id]}
end



return AllMonsterModule


