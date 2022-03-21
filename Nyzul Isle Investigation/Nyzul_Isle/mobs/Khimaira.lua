-----------------------------------
--  MOB: Khimaira
-- Area: Nyzul Isle
-- Info : Floor 60 80 100 Boss
-----------------------------------
mixins = { require("scripts/mixins/nyzul_boss_drops") }
require("scripts/globals/utils/nyzul")
require("scripts/globals/status")
-----------------------------------

function onMobSpawn(mob)
    mob:addImmunity(dsp.immunity.SLEEP)
    mob:addImmunity(dsp.immunity.TERROR)
    mob:setMod(dsp.mod.MEVA, 25)
    mob:setMod(dsp.mod.MAIN_DMG_RATING, 33)
    mob:setMod(dsp.mod.DOUBLE_ATTACK, 15)
    mob:addMod(dsp.mod.ATT, 100)
    mob:addResist({ dsp.resist.ENFEEBLING_STUN, 10, 0 })
    mob:setMobMod(dsp.mobMod.ROAM_DISTANCE, 15)
end

function onMobFight(mob,target)
end

function onMobDeath(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.enemyLeaderKill(mob)
        nyzul.vigilWeaponDrop(player, mob)
        nyzul.handleRunicKey(mob)
    end
end
