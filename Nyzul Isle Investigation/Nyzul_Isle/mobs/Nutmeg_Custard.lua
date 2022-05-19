-----------------------------------
--  MOB: Nutmeg Custard
-- Area: Nyzul Isle
-- Info: Enemy Leader, Absorbs earth elemental damage
-----------------------------------
mixins = {require("scripts/mixins/families/flan")}
require("scripts/globals/status")
require("scripts/globals/utils/nyzul")
-----------------------------------

local this = {}

this.onMobSpawn = function(mob)
    mob:setMod(dsp.mod.EARTH_ABSORB, 100)
    mob:setMod(dsp.mod.REGAIN, 100)
end

this.onMobDeath = function(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.spawnChest(mob, player)
        nyzul.enemyLeaderKill(mob)
    end
end

return this
