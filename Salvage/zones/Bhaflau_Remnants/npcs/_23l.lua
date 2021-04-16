
-----------------------------------
-- NPC: Door
-- Area: Bhaflau Remnants
-- 3rd Floor SW door
-- !pos -400 0 -500, 17084910
-----------------------------------
local ID = require("scripts/zones/Bhaflau_Remnants/IDs")
require("scripts/globals/utils/salvage")
-----------------------------------

function onTrigger(player, npc)
    if player:getInstance():getProgress() == 2 then
        player:startEvent(300)
    else
        player:messageSpecial(ID.text.DOOR_IS_SEALED)
    end
end

function onEventFinish(player, csid, option, npc)
    if csid == 300 and option == 1 then
    	local instance = player:getInstance()
        salvageUtil.onDoorOpen(npc, nil, 6)
        salvageUtil.unsealDoors(npc, ID.npc[3].SOUTH_CENTRAL)
        salvageUtil.spawnGroup(npc, ID.mob[3][6])
    end
end
