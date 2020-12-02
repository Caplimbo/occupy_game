local fight={}

-- key function!
game.ReplicatedStorage.FightControl.pveFight.OnServerEvent:Connect(function(player, monster)
    local u = player.character
    game.ReplicatedStorage.FightControl.OpenItemUI:FireClient(player)
    -- activate the item chosen
    fight:pve(player.character, monster)
    -- deactivate the item chosen.
end)


function fight:pve(Model,Mon)  --变量是玩家扮演的角色的模型和怪物的模型，玩家先手

    local  i=1
    local d=0
    local player=game.Players:GetPlayerFromCharacter(Model)
    --进入战斗状态，不能移动
    Model.infight.Value=1
    --用来等待玩家模型进入格子的时间
    wait(1)
    --打开战斗界面
    player.PlayerGui.BattleUI.Frame.endfight.LocalScript.Disabled=true
    player.PlayerGui.BattleUI.Frame.endfight.Text="fighting···"
    game.ReplicatedStorage.OpenBUI:FireClient(player)
    player.PlayerGui.BattleUI.Frame.TextLabel.Text=""
    --持续战斗直到一方生命值归0
    while (Model.health.Value>0) and (Mon.Health.Value>0)
    do
        if i==1
        then
            d=Model.Attack.Value-Mon.Defense.Value;if d<=0 then d=1 end;
            --先不考虑伤害加成/减免/闪避这类修正
            Mon.Health.Value=Mon.Health.Value-d;
            player.PlayerGui.BattleUI.Frame.TextLabel.Text=player.PlayerGui.BattleUI.Frame.TextLabel.Text..Model.name.Value.." deals "..d.." damage to "..Mon.name.Value.."!"..Mon.name.Value.." has "..Mon.Health.Value.." health left!\n"
        end
        if i==-1
        then
            d=Mon.Attack.Value-Model.Defense.Value;if d<=0 then d=1 end;
            Model.health.Value=Model.health.Value-d;
            player.PlayerGui.BattleUI.Frame.TextLabel.Text=player.PlayerGui.BattleUI.Frame.TextLabel.Text..Mon.name.Value.." deals "..d.." damage to "..Model.name.Value.."!"..Model.name.Value.." has "..Model.health.Value.." health left!\n"
        end

        i=-i;
        wait(0.3);
        --如果采用这句话，用onTouched触发fight系列函数，会出现由于玩家和part一直保持接触状态，Connect会一直触发，导致间隔时间触发的fight让先手的玩家可以超级风怒怒怒怒
        --不过在我们的demo中不影响,因为我们一回合只会触发一次fight，并且不会用onTouched这种持续性的事件
    end
    --战斗结果判定
    if Model.health.Value<=0
    then
        player.PlayerGui.BattleUI.Frame.TextLabel.Text=player.PlayerGui.BattleUI.Frame.TextLabel.Text..Mon.name.Value.." defeats "..Model.name.Value.."!"
        Model:Destroy()--当然不可能被怪打赢一次玩家就死了
    end
    if Mon.Health.Value<=0
    then
        player.PlayerGui.BattleUI.Frame.TextLabel.Text=player.PlayerGui.BattleUI.Frame.TextLabel.Text..Model.name.Value.." defeats "..Mon.name.Value.."!"
        --差pve战斗奖励结算
        Mon:Destroy()
    end
    --玩家可以移动了
    Model.infight.Value=0
    --留给玩家5秒时间查看战斗过程，5秒后自动关闭
    player.PlayerGui.BattleUI.Frame.endfight.LocalScript.Disabled=false
    player.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(5)"
    wait(1)
    player.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(4)"
    wait(1)
    player.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(3)"
    wait(1)
    player.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(2)"
    wait(1)
    player.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(1)"
    wait(1)
    player.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(0)"
    wait(1)
    game.ReplicatedStorage.CloseBUI:FireClient(player)
end



function fight:pvp(Model1,Model2)--两个玩家的模型作为参数，Model1先手，可以在触发战斗前（调用fight.pvp前）随机一个先后手
    local i=1;local d=0;
    Model1.infight.Value=1
    Model2.infight.Value=1
    wait(1)
    local player1=game.Players:GetPlayerFromCharacter(Model1)
    local b1=player1.PlayerGui.BattleUI.Frame.TextLabel.Text
    b1=""
    local player2=game.Players:GetPlayerFromCharacter(Model2)
    local b2=player2.PlayerGui.BattleUI.Frame.TextLabel.Text
    b2=""

    player1.PlayerGui.item.Enabled=true
    player2.PlayerGui.item.Enabled=true
    local j=0
    while((Model1.used.Value==false)or(Model2.used.Value==false))and(j<=5)
    do
        player1.PlayerGui.item.Frame.RestTime.Text="There is "..5-j.." second left!"
        player2.PlayerGui.item.Frame.RestTime.Text="There is "..5-j.." second left!"
        wait(1)
        j=j+1
    end
    player1.PlayerGui.item.Enabled=false
    player2.PlayerGui.item.Enabled=false


    player1.PlayerGui.BattleUI.Frame.endfight.LocalScript.Disabled=true
    player1.PlayerGui.BattleUI.Frame.endfight.Text="fighting···"
    player2.PlayerGui.BattleUI.Frame.endfight.LocalScript.Disabled=true
    player2.PlayerGui.BattleUI.Frame.endfight.Text="fighting···"
    game.ReplicatedStorage.OpenBUI:FireClient(player1)
    game.ReplicatedStorage.OpenBUI:FireClient(player2)
    while (Model1.health.Value>0) and (Model2.health.Value>0)
    do
        if i==1
        then
            d=Model1.Attack.Value-Model2.Defense.Value;if d<=0 then d=1 end;
            --先不考虑伤害加成/减免/闪避这类修正
            Model2.health.Value=Model2.health.Value-d;
            b1=b1..Model1.name.Value.." deals "..d.." damage to "..Model2.name.Value.."!"..Model2.name.Value.." has "..Model2.health.Value.." health left!\n"
            b2=b2..Model1.name.Value.." deals "..d.." damage to "..Model2.name.Value.."!"..Model2.name.Value.." has "..Model2.health.Value.."health left!\n"
        else
            d=Model2.Attack.Value-Model1.Defense.Value;if d<=0 then d=1 end;
            Model1.health.Value=Model1.health.Value-d;
            b1=b1..Model2.name.Value.." deals "..d.." damage to "..Model1.name.Value.."!"..Model1.name.Value.." has "..Model1.health.Value.." health left!\n"
            b2=b2..Model2.name.Value.." deals "..d.." damage to "..Model1.name.Value.."!"..Model1.name.Value.." has "..Model1.health.Value.." health left!\n"
        end
        i=1-i;
        wait(0.3);
    end
    Model1.apu.Value=false
    Model1.dpu.Value=false
    Model2.apu.Value=false
    Model2.dpu.Value=false
    if Model1.health.Value<=0
    then
        b1=b1..Model2.name.Value.." defeats "..Model1.name.Value.."!"
        b2=b2..Model2.name.Value.." defeats "..Model1.name.Value.."!"
        Model1:Destroy()--同理于pve
    end
    if Model2.health.Value<=0
    then
        b1=b1..Model1.name.Value.." defeats "..Model2.name.Value.."!"
        b2=b2..Model1.name.Value.." defeats "..Model2.name.Value.."!"
        Model2:Destroy()
        --差pvp战斗奖励结算
    end
    Model1.infight.Value=0
    Model2.infight.Value=0
    player1.PlayerGui.BattleUI.Frame.endfight.LocalScript.Disabled=false
    player2.PlayerGui.BattleUI.Frame.endfight.LocalScript.Disabled=false
    player1.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(5)"
    player2.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(5)"
    wait(1)
    player1.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(4)"
    player2.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(4)"
    wait(1)
    player1.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(3)"
    player2.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(3)"
    wait(1)
    player1.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(2)"
    player2.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(2)"
    wait(1)
    player1.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(1)"
    player2.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(1)"
    wait(1)
    player1.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(0)"
    player2.PlayerGui.BattleUI.Frame.endfight.Text="leave the battle(0)"
    wait(1)
    game.ReplicatedStorage.CloseBUI:FireClient(player1)
    game.ReplicatedStorage.CloseBUI:FireClient(player2)
end
return fight
