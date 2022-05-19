-----------------------------------
--
-- Zone: Nyzul_Isle
--
-----------------------------------
local ID = require("scripts/zones/Nyzul_Isle/IDs")
require("scripts/globals/instance")
require("scripts/globals/missions")
require("scripts/globals/zone")
-----------------------------------

local this = {}

this.onInitialize = function(zone)
end

this.afterZoneIn = function(player)
    player:entityVisualPacket("1pa1")
    player:entityVisualPacket("1pb1")
    player:entityVisualPacket("2pb1")
end

this.onInstanceZoneIn = function(player, instance)
    local cs = -1

    xi.instance.onZoneIn(player, instance, 1)

    if player:getCurrentMission(TOAU) == PATH_OF_DARKNESS or player:getCurrentAssault() == 51 then
        cs = 51
    end

    return cs
end

this.onEventUpdate = function(player, csid, option)
end

this.onEventFinish = function(player, csid, option, npc)
    xi.instance.kickOut(player, csid, 1, dsp.zone.ALZADAAL_UNDERSEA_RUINS)
end

this.onInstanceLoadFailed = function()
    return dsp.zone.ALZADAAL_UNDERSEA_RUINS
end

return this
