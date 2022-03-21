-----------------------------------
-- Area: Nyzul Isle
--  NM:  Bloodtear_Baldurf
-----------------------------------
mixins = {require("scripts/mixins/job_special")}
require("scripts/globals/utils/nyzul")
-----------------------------------

function onMobDeath(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.spawnChest(mob, player)
        nyzul.eliminateAllKill(mob)
    end
end
