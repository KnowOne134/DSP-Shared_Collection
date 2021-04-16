
-----------------------------------
-- NPC: Door
-- Area: Bhaflau Remnants
-- 3rd Floor NW Door
-- !pos -400 0 -260, 17084912
-----------------------------------
local ID = require("scripts/zones/Bhaflau_Remnants/IDs")
require("scripts/globals/utils/salvage")
-----------------------------------

function onTrigger(player, npc)
    if player:getInstance():getProgress() == 1 then
        player:startEvent(300)
    else
        player:messageSpecial(ID.text.DOOR_IS_SEALED)
    end
end

function onEventFinish(player, csid, option, npc)
    if csid == 300 and option == 1 then
        salvageUtil.onDoorOpen(npc, nil, 5)
        salvageUtil.unsealDoors(npc, ID.npc[3].NORTH_CENTRAL)
        salvageUtil.spawnGroup(npc, ID.mob[3][5])
    end
end
