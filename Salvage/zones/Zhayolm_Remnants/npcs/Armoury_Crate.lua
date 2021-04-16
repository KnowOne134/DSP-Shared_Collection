-----------------------------------
-- Area: Zhayolm Remnants
-- NPC: Armoury Crate (Zhayolm)
-----------------------------------
require("scripts/globals/utils/salvage")
-----------------------------------

function onTrigger(player, npc)
    salvageUtil.onTriggerCrate(player, npc)
end
