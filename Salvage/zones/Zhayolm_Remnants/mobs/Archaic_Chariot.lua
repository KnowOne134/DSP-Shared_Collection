-----------------------------------
-- Area: Zhayolm Remnants
-- MOB: Archaic Chariot
-- HP 30500
-----------------------------------
mixins = {require("scripts/mixins/families/chariot")}
local ID = require("scripts/zones/Zhayolm_Remnants/IDs")
require("scripts/globals/status")
require("scripts/globals/utils/salvage")
-----------------------------------

function onMobSpawn(mob)
    if mob:getID() == ID.mob[6][1].STAGE_START.CHARIOT then
        mob:setMobMod(dsp.mobMod.SUBLINK, 0)
        mob:setMobMod(dsp.mobMod.NO_AGGRO, 1)
    else
        mob:setMobMod(dsp.mobMod.NO_ROAM, 1)
    end
end

function onMobEngaged(mob, target)
    local instance = mob:getInstance()
    local stage = instance:getStage()

    if stage == 6 then
        salvageUtil.spawnGroup(mob, ID.mob[6][1].CHARIOT_GEARS)
    end
end

function onMobDeath(mob, player, isKiller, firstCall)
    if firstCall then
        local instance = mob:getInstance()
        local stage = instance:getStage()
        local progress = instance:getProgress()

        if stage == 6 then
            instance:setLocalVar("6th Door",instance:getLocalVar("6th Door") + 1)
        end
        if math.random(1,1000) >= 960 then
            local params = {}
            salvageUtil.spawnTempChest(mob, params)
        end
    end
end
