-----------------------------------
-- NPC: Door
-- Area: Bhaflau Remnants
-- 1st floor East exit door
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
        salvageUtil.onDoorOpen(npc, nil, 3)
        salvageUtil.unsealDoors(npc, ID.npc[1].CENTER_ENTRANCE)
        salvageUtil.spawnStage(player)
    end
end