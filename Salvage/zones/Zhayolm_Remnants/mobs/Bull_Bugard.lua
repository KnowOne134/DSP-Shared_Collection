-----------------------------------
-- Area: Zhayolm Remnants
-- MOB: Bull Bugard
-----------------------------------
local ID = require("scripts/zones/Zhayolm_Remnants/IDs")
require("scripts/globals/status")
require("scripts/globals/utils/salvage")
-----------------------------------

function onMobDeath(mob, player, isKiller, firstCall)
    if firstCall then
        local instance = mob:getInstance()

        if salvageUtil.groupKilled(mob, ID.mob[1][1].STAGE_START.BUGARD) then
            SpawnMob(ID.mob[1].POROGGO_GENT_BUGARD, instance):setDropID(7302)
        end
        if math.random(1,1000) >= 960 then
            local params = {}
            salvageUtil.spawnTempChest(mob, params)
        end
    end
end
