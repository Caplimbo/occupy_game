---function used when player click on a brick:

function move(player, part)
    -- judge, move to the new location
    -- to be completed

    -- collect item
    if (part.itemID ~= 0) then
        local itemID = part.itemID
        part.itemID = 0 -- eliminate item from part
        player.itemID = itemID  -- give the item to player.
    end

    -- fight
    -- pve
    if (part.monsterID ~= 0) then
        -- fight method
    end

    --pvp
    if (part.playerID ~= 0) then
        -- fight method
    end
end