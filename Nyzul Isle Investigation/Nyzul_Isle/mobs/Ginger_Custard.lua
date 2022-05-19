-----------------------------------
--  MOB: Ginger Custard
-- Area: Nyzul Isle
-- Info: Enemy Leader, Absorbs fire elemental damage, Highly resistant to silence, Gains regain at 50% HP
-----------------------------------
mixins = {require("scripts/mixins/families/flan")}
require("scripts/globals/status")
require("scripts/globals/utils/nyzul")
-----------------------------------

local this = {}

this.onMobInitialize = function(mob)
    mob:setMod(dsp.mod.FIRE_ABSORB, 100)
    mob:setMod(dsp.mod.SILENCERES, 80)
end

this.onMobFight = function(mob, target)
    if mob:getLocalVar("Regain") == 0 then
        if mob:getHPP() <= 50 then
            mob:setMod(dsp.mod.REGAIN, 100)
            mob:setLocalVar("Regain", 1)
        end
    end
end

this.onMobDeath = function(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.spawnChest(mob, player)
        nyzul.enemyLeaderKill(mob)
    end
end

return this
