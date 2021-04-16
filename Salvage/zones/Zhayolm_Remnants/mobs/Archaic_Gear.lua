-----------------------------------
-- Area: Zhayolm Remnants
-- MOB: Archaic Gear
-----------------------------------
mixins = {require("scripts/mixins/families/gear")}
local ID = require("scripts/zones/Zhayolm_Remnants/IDs")
require("scripts/globals/pathfind")
require("scripts/globals/status")
require("scripts/globals/utils/salvage")
-----------------------------------

function onMobSpawn(mob)
    instance = mob:getInstance()

    if instance:getStage() == 5 and instance:getProgress() == 2 then
        if mob:getID() >= 17076503 and mob:getID() <= 17076510 then
            onMobRoam(mob)
        end
    elseif instance:getStage() == 6 then
        mob:addImmunity(dsp.immunity.DARKSLEEP)
        onMobRoam(mob)
    end
end

function onPath(mob)
    local instance = mob:getInstance()
    local stage = instance:getStage()
    local progress = instance:getProgress()
    local mobID = mob:getID()
    local offset = 0

    if mobID >= 17076503 and mobID <= 17076510 then
        offset = 17076502
    elseif mobID >= 17076571 then
        offset = 17076560
    end

    if offset > 0 then
        local pathID = mob:getID() - offset
        dsp.path.patrol(mob, ID.path[stage][progress][pathID])
    end
end

function onMobRoam(mob)
    local instance = mob:getInstance()
    local stage = instance:getStage()
    local progress = instance:getProgress()
    local mobID = mob:getID()
    local offset = 0

    if mobID >= 17076503 and mobID <= 17076510 then
        offset = 17076502
    elseif mobID >= 17076571 then
        offset = 17076560
    end

    if offset > 0 then
        local pathID = mobID - offset
        if not mob:isFollowingPath() then
            mob:pathThrough(dsp.path.first(ID.path[stage][progress][pathID]))
        end
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
