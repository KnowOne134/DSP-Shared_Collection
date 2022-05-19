-----------------------------------
--  MOB: Mint Custard
-- Area: Nyzul Isle
-- Info: Enemy Leader, Absorbs lightning elemental damage
-----------------------------------
mixins = {require("scripts/mixins/families/flan")}
require("scripts/globals/status")
require("scripts/globals/utils/nyzul")
-----------------------------------

local this = {}

this.onMobInitialize = function(mob)
    mob:setMod(dsp.mod.LTNG_ABSORB, 100)
end

this.onMobDeath = function(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.spawnChest(mob, player)
        nyzul.enemyLeaderKill(mob)
    end
end

return this
