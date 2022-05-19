-----------------------------------
-- Area: Nyzul Isle
--  NM:  Bloodtear_Baldurf
-----------------------------------
mixins = {require("scripts/mixins/job_special")}
require("scripts/globals/utils/nyzul")
-----------------------------------

local this = {}

this.onMobDeath = function(mob, player, isKiller, firstCall)
    if firstCall then
        nyzul.spawnChest(mob, player)
        nyzul.eliminateAllKill(mob)
    end
end

return this
