-----------------------------------
-- Area: Nyzul Isle
-- NM: Steelfleece Baldarich
-----------------------------------
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
