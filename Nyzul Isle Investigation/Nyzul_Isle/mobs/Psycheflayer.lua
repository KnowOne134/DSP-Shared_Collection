-----------------------------------
--  MOB: Psycheflayer
-- Area: Nyzul Isle
-- Info: Specified Mob Group and Eliminate all Group
-----------------------------------
require("scripts/globals/utils/nyzul")
-----------------------------------

local this = {}

this.onMobSpawn = function(mob)
    nyzul.specifiedEnemySet(mob)
    if mob:getPool() == 8072 then
        mob:setMobMod(dsp.mobMod.CHECK_AS_NM, 1)
    end
end

this.onMobDeath = function(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.spawnChest(mob, player)
        nyzul.specifiedEnemyKill(mob)
        if mob:getID() >= 17092974 then
            nyzul.specifiedGroupKill(mob)
        end
    end
end

return this
