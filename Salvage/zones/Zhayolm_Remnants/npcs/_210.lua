-----------------------------------
-- Door
-- Floor 1 Begining Door
-- !pos 400 -2 -560
-----------------------------------
local ID = require("scripts/zones/Zhayolm_Remnants/IDs")
require("scripts/globals/status")
require("scripts/globals/utils/salvage")
-----------------------------------

function onTrigger(player, npc)
    player:startEvent(300)
end

function onEventFinish(player, csid, option, npc)
    local instance = npc:getInstance()

    if csid == 300 and option == 1 then
        instance:setLocalVar("allySize", player:getPartySize(0))
        salvageUtil.onDoorOpen(npc, nil, 1)
        salvageUtil.unsealDoors(npc, ID.npc[1].DOORS)
        salvageUtil.spawnStage(player)
    end
end
