-----------------------------------
-- Area: Bhaflau Remnants
--  MOB: Troll Cameist
-----------------------------------
require("scripts/globals/utils/salvage")
-----------------------------------

function onMobDeath(mob, player, isKiller, firstCall)
	if firstCall then
        if math.random(1,1000) >= 960 then
            local params = {}
            salvageUtil.spawnTempChest(mob, params)
        end
    end
end