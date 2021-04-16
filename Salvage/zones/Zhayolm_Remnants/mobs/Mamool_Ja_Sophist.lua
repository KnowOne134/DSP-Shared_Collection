-----------------------------------
-- Area: Zhayolm Remnants
-- MOB: Mamool Ja Sophist
-----------------------------------
local ID = require("scripts/zones/Zhayolm_Remnants/IDs")
require("scripts/globals/status")
require("scripts/globals/utils/salvage")
-----------------------------------

function onMobDeath(mob, player, isKiller, firstCall)
    if firstCall then
        local instance = mob:getInstance()
        local stage = instance:getStage()

        if stage == 3 then
            if salvageUtil.groupKilled(mob, ID.mob[3][0].STAGE_START.NORTH_PATH) then
                local mobID = ID.mob[3].POROGGO_MADAME
                local stageBoss = instance:getEntity(bit.band(mobID, 0xFFF), dsp.objType.MOB)
                if stageBoss:getLocalVar("spawned") == 0 then
                    SpawnMob(mobID, instance):setPos(300, -4, 526)
                    stageBoss:setDropID(7324)
                    stageBoss:setLocalVar("spawned", 1)
                end
            end
        end
        if math.random(1,1000) >= 960 then
            local params = {}
            salvageUtil.spawnTempChest(mob, params)
        end
    end
end
