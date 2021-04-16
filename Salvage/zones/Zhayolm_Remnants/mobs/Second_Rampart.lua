-----------------------------------
-- Area: Zhayolm Remnants
-- MOB: Second Rampart
-----------------------------------
mixins =
{
    require("scripts/mixins/master"),
    require("scripts/mixins/families/rampart")
}
local ID = require("scripts/zones/Zhayolm_Remnants/IDs")
require("scripts/globals/status")
require("scripts/globals/utils/salvage")
require("scripts/globals/weather")
-----------------------------------

function onMobSpawn(mob)
    local instance = mob:getInstance()
    mob:setMobMod(dsp.mobMod.NO_AGGRO, 1)
    mob:setMobMod(dsp.mobMod.NO_ROAM, 1)
    mob:setPet(instance:getEntity(bit.band(mob:getID() + 4, 0xFFF), dsp.objType.MOB))
end

function onMobEngaged(mob, target)
    local instance = mob:getInstance()
    local mobID = mob:getID()

    DespawnMob(mobID - 1, instance)
    DespawnMob(mobID + 1, instance)
    DespawnMob(mobID + 2, instance)
end

function onMobDeath(mob, player, isKiller, firstCall)
    if firstCall then
        local instance = mob:getInstance()
        local enteringDay = instance:getLocalVar("dayElement") - 1

        salvageUtil.unsealDoors(mob, ID.npc[4][instance:getProgress()].DOOR)

        if enteringDay == dsp.day.WATERSDAY or enteringDay == dsp.day.WINDSDAY then
            instance:setLocalVar("repeatFloor", 0)
        end
    end
end
