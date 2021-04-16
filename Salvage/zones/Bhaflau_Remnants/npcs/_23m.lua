
-----------------------------------
-- NPC: Door
-- Area: Bhaflau Remnants
-- 3rd Floor central west to portal
-- !pos -460 -4 -480, 17084911
-----------------------------------
local ID = require("scripts/zones/Bhaflau_Remnants/IDs")
require("scripts/globals/utils/salvage")
-----------------------------------

function onTrigger(player, npc)
    if npc:getLocalVar("unSealed") == 1 then
        player:startEvent(300)
    else
        player:messageSpecial(ID.text.DOOR_IS_SEALED)
    end
end

function onEventFinish(player, csid, option, npc)
    if csid == 300 and option == 1 then
        salvageUtil.onDoorOpen(npc)
        salvageUtil.sealDoors(npc, ID.npc[3].EAST_EXIT)
    end
end
