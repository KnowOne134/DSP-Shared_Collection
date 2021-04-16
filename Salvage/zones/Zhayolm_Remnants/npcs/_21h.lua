-----------------------------------

-----------------------------------
local ID = require("scripts/zones/Zhayolm_Remnants/IDs")
require("scripts/globals/status")
require("scripts/globals/utils/salvage")
-----------------------------------

function onTrigger(player, npc)
    player:startEvent(300)
end

function onEventFinish(player, csid, option, npc)
    if csid == 300 and option == 1 then
        local instance = npc:getInstance()
        instance:getEntity(bit.band(npc:getID() + 1, 0xFFF), dsp.objType.NPC):setStatus(dsp.status.DISAPPEAR)
        salvageUtil.onDoorOpen(npc)
    end
end
