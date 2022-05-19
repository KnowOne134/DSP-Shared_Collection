-----------------------------------
--  MOB: Vile Ineef
-- Area: Nyzul Isle
-- Info: Enemy Leader
-----------------------------------
require("scripts/globals/utils/nyzul")
-----------------------------------

local this = {}

this.onMobInitialize = function(mob)
    mob:addImmunity(dsp.immunity.DARKSLEEP)
end

this.onMobDeath = function(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.spawnChest(mob, player)
        nyzul.enemyLeaderKill(mob)
    end
end

return this
