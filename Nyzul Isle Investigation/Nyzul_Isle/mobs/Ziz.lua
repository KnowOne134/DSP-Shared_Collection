-----------------------------------
--  MOB: Ziz
-- Area: Nyzul Isle
-----------------------------------
require("scripts/globals/utils/nyzul")
mixins = {require("scripts/mixins/families/ziz")}
-----------------------------------

local this = {}

this.onMobSpawn = function(mob)
    nyzul.specifiedEnemySet(mob)
    mob:AnimationSub(13)
end

this.onMobDeath = function(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.spawnChest(mob, player)
        nyzul.specifiedEnemyKill(mob)
    end
end

return this
