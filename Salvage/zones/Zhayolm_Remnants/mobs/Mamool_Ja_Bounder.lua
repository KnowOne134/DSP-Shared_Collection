-----------------------------------
-- Area: Zhayolm Remnants
-- MOB: Mamool Ja Bounder (THF)
-----------------------------------
local ID = require("scripts/zones/Zhayolm_Remnants/IDs")
require("scripts/globals/status")
require("scripts/globals/utils/salvage")
-----------------------------------

function onMobDeath(mob, player, isKiller, firstCall)
    if firstCall then
        local instance = mob:getInstance()
        local stage = instance:getStage()
        local progress = instance:getProgress()

        if stage == 2 and progress == 4 then
            instance:setProgress(5)
            instance:getEntity(bit.band(ID.npc[stage].SOCKET, 0xFFF), dsp.objType.NPC):setStatus(dsp.status.NORMAL)
            salvageUtil.unsealDoors(mob, ID.npc[2].DOORS)
            salvageUtil.spawnGroup(player, ID.mob[2][1].STAGE_START.NORTH_EAST)
            salvageUtil.spawnGroup(player, ID.mob[2][2].STAGE_START.SOUTH_EAST)
            salvageUtil.spawnGroup(player, ID.mob[2][3].STAGE_START.SOUTH_WEST)
        elseif stage == 3 then
            if salvageUtil.groupKilled(mob, ID.mob[3][0].STAGE_START.SOUTH_PATH) then
                local mobID = ID.mob[3].POROGGO_MADAME
                local stageBoss = instance:getEntity(bit.band(mobID, 0xFFF), dsp.objType.MOB)
                if stageBoss:getLocalVar("spawned") == 0 then
                    SpawnMob(mobID, instance):setPos(380, -4, 389)
                    stageBoss:setDropID(7325)
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
