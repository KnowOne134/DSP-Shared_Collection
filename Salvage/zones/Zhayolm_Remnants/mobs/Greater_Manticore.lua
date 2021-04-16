-----------------------------------
-- Area: Zhayolm Remnants
-- MOB: Greater Manticore
-----------------------------------
mixins = {require("scripts/mixins/pet")}
require("scripts/globals/utils/salvage")
-----------------------------------

function onMobDeath(mob, player, isKiller, firstCall)
    if firstCall then
        local params = {}
        salvageUtil.spawnTempChest(mob, params)
    end
end
