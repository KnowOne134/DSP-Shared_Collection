-----------------------------------
--  MOB: Hydra
-- Area: Nyzul Isle
-- Info: Floor 60 80 and 100 Boss
-----------------------------------
mixins = { require("scripts/mixins/nyzul_boss_drops") }
require("scripts/globals/utils/nyzul")
require("scripts/globals/status")
-----------------------------------

local this = {}

this.onMobSpawn = function(mob)
    mob:setMod(dsp.mod.DOUBLE_ATTACK, 10)
    mob:setMod(dsp.mod.UDMGMAGIC, -90)
    mob:setMod(dsp.mod.POISONRES, 100)
    mob:setMod(dsp.mod.BLINDRES, 100)
    mob:addImmunity(dsp.immunity.BIND)
    mob:addImmunity(dsp.immunity.GRAVITY)
    mob:addImmunity(dsp.immunity.PARALYZE)
    mob:addImmunity(dsp.immunity.TERROR)
    mob:setMod(dsp.mod.SILENCERES, 100)
    mob:setMod(dsp.mod.SLOWRES, 100)
    mob:setMod(dsp.mod.STUNRES, 175)
    mob:setMod(dsp.mod.SLEEPRES_LIGHT, 150)
    mob:setMod(dsp.mod.SLEEPRES_DARK, 150)
    mob:setMod(dsp.mod.DEFP, 35)
    mob:addMod(dsp.mod.EVA, 15)
    mob:setMod(dsp.mod.MAIN_DMG_RATING, 40)
    mob:setMobMod(dsp.mobMod.ROAM_DISTANCE, 15)
end

this.handleRegen = function(mob, broken)
    local multiplier = (2 - broken) * .75
    mob:setMod(dsp.mod.REGEN, math.floor(25 * multiplier))
    mob:setMod(dsp.mod.REGAIN, math.floor(25 * multiplier))
end

this.onMobEngaged = function(mob)
    this.handleRegen(mob, mob:AnimationSub())
end

this.onMobFight = function(mob, target)
    local battletime = os.time()
    local headgrow = mob:getLocalVar("headgrow")
    local broken = mob:AnimationSub()

    if headgrow < battletime and broken > 0 then
        mob:AnimationSub(broken - 1)
        mob:setLocalVar("headgrow", battletime + 300)
        mob:setTP(3000)
        this.handleRegen(mob, broken - 1)
    end

end

this.onCriticalHit = function(mob)
    local rand = math.random(1, 100)
    local battletime = os.time()
    local headgrow = mob:getLocalVar("headgrow")
    local broken = mob:AnimationSub()

    if rand <= 15 and broken < 2 then
        mob:AnimationSub(broken + 1)
        mob:setLocalVar("headgrow", os.time() + math.random(120, 240))
        this.handleRegen(mob, broken + 1)
    end

end

this.onMobDeath = function(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.enemyLeaderKill(mob)
        nyzul.vigilWeaponDrop(player, mob)
        nyzul.handleRunicKey(mob)
    end
end

return this
