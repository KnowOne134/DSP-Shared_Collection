-----------------------------------
-- Area: Zhayolm Remnants
-- MOB: Jakko
-----------------------------------
local ID = require("scripts/zones/Zhayolm_Remnants/IDs")
require("scripts/globals/status")
-----------------------------------

function onMobDeath(mob, player, isKiller, firstCall)
    if firstCall then
        local instance = mob:getInstance()
        local stage = instance:getStage()

        if stage == 2 then
            instance:setLocalVar("killedNMs", instance:getLocalVar("killedNMs") + 1)
        end
        if math.random(1,1000) >= 960 then
            salvageUtil.spawnTempChest(mob)
        end
    end
end
