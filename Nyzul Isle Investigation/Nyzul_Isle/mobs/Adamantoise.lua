-----------------------------------
--  MOB: Adamantoise
-- Area: Nyzul Isle
-- Info: Floor 20 and 40 Boss, Tortoise song dispels 3 buffs
-----------------------------------
mixins = { require("scripts/mixins/nyzul_boss_drops") }
require("scripts/globals/utils/nyzul")
require("scripts/globals/status")
-----------------------------------

function onMobSpawn(mob)
    mob:addImmunity(dsp.immunity.STUN)
    mob:addImmunity(dsp.immunity.SLOW)
    mob:addImmunity(dsp.immunity.ELEGY)
    mob:addImmunity(dsp.immunity.TERROR)
    mob:addImmunity(dsp.immunity.SLEEP)
    mob:addImmunity(dsp.immunity.POISON)
    mob:setMod(dsp.mod.MAIN_DMG_RATING, 36)
    mob:addMod(dsp.mod.DEF, 200)
    mob:addMod(dsp.mod.ATT, 150)
    mob:setMobMod(dsp.mobMod.ROAM_DISTANCE, 15)
end

function onMobEngaged(mob,target)
end

function onMobFight(mob,target)
end

function onMobDeath(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.enemyLeaderKill(mob)
        nyzul.vigilWeaponDrop(player, mob)
    end
end
