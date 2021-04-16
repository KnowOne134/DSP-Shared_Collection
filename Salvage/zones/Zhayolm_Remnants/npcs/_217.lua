-----------------------------------
-- Door
-- Floor 2 Exit North West Room
-- !pos 320 -2 20
-----------------------------------
local ID = require("scripts/zones/Zhayolm_Remnants/IDs")
require("scripts/globals/status")
require("scripts/globals/utils/salvage")
-----------------------------------

function onTrigger(player, npc)
    local instance = npc:getInstance()
    local progress = instance:getProgress()

    if npc:getLocalVar("unSealed") == 1 or progress == 4 then
        player:startEvent(300)
    else
        player:messageSpecial(ID.text.DOOR_IS_SEALED)
    end
end

function onEventFinish(player, csid, option, npc)
    if csid == 300 and option == 1 then
        salvageUtil.onDoorOpen(npc)
    end
end
