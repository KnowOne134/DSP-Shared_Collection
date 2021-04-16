-----------------------------------
-- Area: Zhayolm Remnants
-- NPC: Armoury Crate (Zhayolm) Temp Items
-----------------------------------
require("scripts/globals/utils/salvage")
-----------------------------------

function onTrigger(player, npc)
    salvageUtil.tempBoxTrigger(player, npc)
end

function onEventFinish(player, csid, option, npc)
    salvageUtil.tempBoxFinish(player, csid, option, npc)
end
