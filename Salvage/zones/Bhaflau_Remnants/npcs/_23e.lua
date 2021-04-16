
-----------------------------------
-- NPC: Door
-- Area: Bhaflau Remnants
-- 2nd floor 2nd door West Wing, opens SW section, locks NW Wing
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
        salvageUtil.sealDoors(npc, ID.npc[2].NW_ENTRANCE)
        salvageUtil.unsealDoors(npc, ID.npc[2].SW_EXIT)
        salvageUtil.spawnGroup(npc, ID.mob[2][2].SOUTH_WEST)
    end
end
