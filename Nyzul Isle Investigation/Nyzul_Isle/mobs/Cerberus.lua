-----------------------------------
--  MOB: Cerberus
-- Area: Nyzul Isle
-- Info: Floor 60 80 and 100 Boss
-----------------------------------
mixins = { require("scripts/mixins/nyzul_boss_drops") }
require("scripts/globals/utils/nyzul")
require("scripts/globals/status")
-----------------------------------

function onMobSpawn(mob)
    mob:setMod(dsp.mod.DOUBLE_ATTACK, 20)
    mob:setMod(dsp.mod.REGEN, 10) -- validate
    -- mdt already set in mob family mods
    mob:setMod(dsp.mod.POISONRES, 100)
    mob:setMod(dsp.mod.PARALYZERES, 100)
    mob:setMod(dsp.mod.BLINDRES, 100)
    mob:setMod(dsp.mod.SILENCERES, 100)
    mob:setMod(dsp.mod.SLOWRES, 125)
    mob:addMod(dsp.mod.ATT, 75)
    mob:setMod(dsp.mod.DEFP, 48)
    mob:setMod(dsp.mod.MAIN_DMG_RATING, 40)
    mob:addImmunity(dsp.immunity.SLEEP)
    mob:addImmunity(dsp.immunity.TERROR)
    mob:setMobMod(dsp.mobMod.ROAM_DISTANCE, 15)
end

function onMobFight(mob,target)
    if mob:getHPP() > 25 then
        mob:setMod(dsp.mod.REGAIN, 10)
    else
        mob:setMod(dsp.mod.REGAIN, 70)
    end
end

function onMobDeath(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.enemyLeaderKill(mob)
        nyzul.vigilWeaponDrop(player, mob)
        nyzul.handleRunicKey(mob)
    end
end
