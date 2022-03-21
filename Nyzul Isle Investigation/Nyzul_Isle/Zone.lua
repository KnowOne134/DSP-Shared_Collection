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

function onInitialize(zone)
end

function afterZoneIn(player)
    player:entityVisualPacket("1pa1")
    player:entityVisualPacket("1pb1")
    player:entityVisualPacket("2pb1")
end

function onInstanceZoneIn(player, instance)
    local cs = -1

    InstanceOnZoneIn(player, instance, 1)

    if player:getCurrentMission(TOAU) == PATH_OF_DARKNESS or player:getCurrentAssault() == 51 then
        cs = 51
    end
    
    return cs
end

function onEventUpdate(player, csid, option)
end

function onEventFinish(player, csid, option, npc)
    instanceKickOut(player, csid, 1, dsp.zone.ALZADAAL_UNDERSEA_RUINS)
end

function onInstanceLoadFailed()
    return dsp.zone.ALZADAAL_UNDERSEA_RUINS
end
