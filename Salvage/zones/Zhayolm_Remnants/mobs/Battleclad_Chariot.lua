-----------------------------------
-- Area: Zhayolm Remnants
--   NM: Battleclad Chariot
-----------------------------------
mixins = {require("scripts/mixins/families/chariot")}
require("scripts/globals/status")
require("scripts/globals/titles")
-----------------------------------

function onMobSpawn(mob)
    mob:addMobMod(dsp.mobMod.NO_ROAM, 1)
end

function onMobDeath(mob, player, isKiller, firstCall)
    player:addTitle(dsp.title.STAR_CHARIOTEER)
end