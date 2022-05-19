-----------------------------------
-- Area: Nyzul Isle
--  MOB: Qiqirn Mine
-- Note: Explosive mine from Qiqrin
-----------------------------------
require("scripts/globals/status")
-----------------------------------

local this = {}

this.onMobSpawn = function(mob)
    mob:setUnkillable(true)
    mob:hideHP(true)
    mob:SetAutoAttackEnabled(false)
    mob:setStatus(dsp.status.DISAPPEAR)
    mob:setMobMod(dsp.mobMod.ALWAYS_AGGRO, 1)
    mob:setMobMod(dsp.mobMod.NO_MOVE, 1)
    mob:setMobMod(dsp.mobMod.SIGHT_RANGE, 15)
    mob:setMobMod(dsp.mobMod.SOUND_RANGE, 15)
end

this.onMobDeath = function(mob, player, isKiller, firstCall)
end

return this
