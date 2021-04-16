-----------------------------------
-- Area: Bhaflau Remnants
--  MOB: Long-Bowed_Chariot
-----------------------------------
mixins = {require("scripts/mixins/families/chariot")}
require("scripts/globals/status")
require("scripts/globals/titles")
-----------------------------------

function onMobSpawn(mob)
    local instance = mob:getInstance()

    mob:addImmunity(dsp.immunity.BIND)
    mob:addImmunity(dsp.immunity.SLEEP)
    mob:addMobMod(dsp.mobMod.NO_ROAM, 1)
    mob:addResist({ dsp.resist.ENFEEBLING_STUN, 75, 0 })
    if instance:getLocalVar("bossModifier") == 1 then
        mob:addMod(dsp.mod.DEF, -100)
        mob:addMod(dsp.mod.MDEF, -100)
    elseif instance:getLocalVar("bossModifier") == 2 then
        mob:addMod(dsp.mod.ATTACK, -100)
    end
end

function onMobDeath(mob, player, isKiller, firstCall)
    player:addTitle(dsp.title.COMET_CHARIOTEER)
end