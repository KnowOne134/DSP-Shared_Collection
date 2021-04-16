-----------------------------------
-- Area: Bhaflau Remnants
-- NPC: Armoury Crate (Bhaflau)
-----------------------------------
require("scripts/globals/utils/salvage")
-----------------------------------

function onTrigger(player, npc)
    salvageUtil.onTriggerCrate(player, npc)
end
