-----------------------------------
--  MOB: Fafnir
-- Area: Nyzul Isle
-- Info: Floor 20 and 40 Boss, Hurricane Wing is stronger than normal
-----------------------------------
mixins = { require("scripts/mixins/nyzul_boss_drops") }
require("scripts/globals/utils/nyzul")
require("scripts/globals/status")
-----------------------------------
function onMobInitialize(mob)
    mob:setMobMod(dsp.mobMod.NO_MP, 1)
end

function onMobSpawn(mob)
    mob:addImmunity(dsp.immunity.SLEEP)
    mob:addImmunity(dsp.immunity.TERROR)
    mob:addMod(dsp.mod.ATT, 150)
    mob:addMod(dsp.mod.DEF, 90)
    mob:setMod(dsp.mod.MAIN_DMG_RATING, 33)
    mob:setMod(dsp.mod.DOUBLE_ATTACK, 25)
    mob:setMobMod(dsp.mobMod.ROAM_DISTANCE, 15)
end

function onMobFight(mob,target)
end

function onMobDeath(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.enemyLeaderKill(mob)
        nyzul.vigilWeaponDrop(player, mob)
    end
end
