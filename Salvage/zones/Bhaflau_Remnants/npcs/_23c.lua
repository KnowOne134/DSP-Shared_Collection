
-----------------------------------
-- NPC: Door
-- Area: Bhaflau Remnants
-- 2nd floor 1st door opens East Wing, locks West Wing
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
    	local instance = player:getInstance()
        salvageUtil.onDoorOpen(npc, nil, 1)
        salvageUtil.sealDoors(npc, ID.npc[2].WEST_ENTRANCE)
        salvageUtil.unsealDoors(npc, ID.npc[2].SE_ENTRANCE)
        salvageUtil.unsealDoors(npc, ID.npc[2].NE_ENTRANCE)
        salvageUtil.spawnStage(player)

        if math.random(100) >= 50 then
            instance:getEntity(bit.band(ID.npc[2].SOCKET, 0xFFF), dsp.objType.NPC):setPos(458,0,260)
            instance:getEntity(bit.band(ID.npc[2].SOCKET, 0xFFF), dsp.objType.NPC):setStatus(dsp.status.NORMAL)
        end
    end
end
