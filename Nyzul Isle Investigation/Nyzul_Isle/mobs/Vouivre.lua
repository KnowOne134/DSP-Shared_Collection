-----------------------------------
--  MOB: Vouivre
-- Area: Nyzul Isle
-- Info: NM
-----------------------------------
require("scripts/globals/utils/nyzul")
require("scripts/globals/status")
-----------------------------------

local this = {}

this.onMobInitialize = function(mob)
    mob:setMod(dsp.mod.REGEN, 5)
    mob:setMod(dsp.mod.DOUBLE_ATTACK, 40)
    mob:setMod(dsp.mod.TRIPLE_ATTACK, 35)
    mob:addImmunity(dsp.immunity.TERROR)
end

this.onMobDeath = function(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.spawnChest(mob, player)
        nyzul.eliminateAllKill(mob)
    end
end

return this
