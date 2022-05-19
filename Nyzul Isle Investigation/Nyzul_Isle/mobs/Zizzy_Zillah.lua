-----------------------------------
--  MOB: Zizzy Zillah
-- Area: Nyzul Isle
-- Info: NM
-----------------------------------
mixins = {require("scripts/mixins/families/ziz")}
require("scripts/globals/utils/nyzul")
-----------------------------------

local this = {}

this.onMobSpawn = function(mob)
    mob:AnimationSub(13)
end

this.onMobDeath = function(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.spawnChest(mob, player)
        nyzul.eliminateAllKill(mob)
    end
end

return this
