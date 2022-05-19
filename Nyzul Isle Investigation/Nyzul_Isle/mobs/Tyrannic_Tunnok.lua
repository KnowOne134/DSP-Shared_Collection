-----------------------------------
--  MOB: Tyrannic Tunnok
-- Area: Nyzul Isle
-- Info: NM
-----------------------------------
require("scripts/globals/utils/nyzul")
require("scripts/globals/additional_effects")
require("scripts/globals/status")
-----------------------------------

local this = {}

this.onMobInitialize = function(mob)
    mob:setMobMod(dsp.mobMod.ADD_EFFECT, 1)
end

this.onAdditionalEffect = function(mob, player)
    return effectUtil.mobOnAddEffect(mob, player, damage, effectUtil.mobAdditionalEffect.POISON, {chance = 40, tick = 50, duration = 15})
end

this.onMobDeath = function(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.spawnChest(mob, player)
        nyzul.eliminateAllKill(mob)
    end
end

return this
