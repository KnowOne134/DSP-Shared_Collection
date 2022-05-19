-----------------------------------
--  MOB: Bat Eye
-- Area: Nyzul Isle
-- Info: NM
-----------------------------------
require("scripts/globals/status")
require("scripts/globals/utils/nyzul")
-----------------------------------

local this = {}

this.onMobSpawn = function(mob)
    mob:setMobMod(dsp.mobMod.CHECK_AS_NM, 1)
end

this.onMobDeath = function(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.spawnChest(mob, player)
        nyzul.eliminateAllKill(mob)
    end
end

return this
