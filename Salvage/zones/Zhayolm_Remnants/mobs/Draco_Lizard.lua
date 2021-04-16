-----------------------------------
-- Area: Zhayolm Remnants
-- MOB: Draco Lizard
-----------------------------------
local ID = require("scripts/zones/Zhayolm_Remnants/IDs")
require("scripts/globals/status")
require("scripts/globals/utils/salvage")
-----------------------------------

function onMobDeath(mob, player, isKiller, firstCall)
    local instance = mob:getInstance()
    local stage = instance:getStage()

    if firstCall and stage == 2 then
        if salvageUtil.groupKilled(mob, ID.mob[2][1].STAGE_START.NORTH_EAST) then
            local stageBoss = ID.mob[2][1].MAMOOL_JA
            if instance:getEntity(bit.band(stageBoss, 0xFFF), dsp.objType.MOB):getLocalVar("spawned") == 0 then
                SpawnMob(stageBoss, instance)
                instance:getEntity(bit.band(stageBoss, 0xFFF), dsp.objType.MOB):setLocalVar("spawned", 1)
            end
        end
        if salvageUtil.groupKilled(mob, ID.mob[2][2].STAGE_START.SOUTH_EAST) then
            local stageBoss = ID.mob[2][2].MAMOOL_JA
            if instance:getEntity(bit.band(stageBoss, 0xFFF), dsp.objType.MOB):getLocalVar("spawned") == 0 then
                SpawnMob(stageBoss, instance)
                instance:getEntity(bit.band(stageBoss, 0xFFF), dsp.objType.MOB):setLocalVar("spawned", 1)
            end
        end
        if math.random(1,1000) >= 960 then
            local params = {}
            salvageUtil.spawnTempChest(mob, params)
        end
    end
end
