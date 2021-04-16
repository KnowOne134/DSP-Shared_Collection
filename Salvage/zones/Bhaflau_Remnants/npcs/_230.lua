-----------------------------------
-- NPC: Door
-- Area: Bhaflau Remnants
-- 1st Floor 1st door
-- !pos 340 14 -520
-----------------------------------
local ID = require("scripts/zones/Bhaflau_Remnants/IDs")
require("scripts/globals/utils/salvage")
-----------------------------------

function onTrigger(player, npc)
    player:startEvent(300)
end

function onEventFinish(player, csid, option, npc)
    if csid == 300 and option == 1 then
        salvageUtil.onDoorOpen(npc)
        salvageUtil.unsealDoors(npc, ID.npc[1].EAST_ENTRANCE)
        salvageUtil.unsealDoors(npc, ID.npc[1].WEST_ENTRANCE)
    end
end
