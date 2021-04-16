-----------------------------------
--
-- Zone: Bhaflau_Remnants
--
-----------------------------------
local ID = require("scripts/zones/Bhaflau_Remnants/IDs")
require("scripts/globals/instance")
require("scripts/globals/zone")
-----------------------------------

function onInitialize(zone)
    zone:registerRegion(1,  340, 8, -420, 0, 0, 0)
    zone:registerRegion(2,  260, 8,  300, 0, 0, 0)
    zone:registerRegion(3,  300, 8,   60, 0, 0, 0)
    zone:registerRegion(4,  420, 8,  300, 0, 0, 0)
    zone:registerRegion(5,  380, 8,   60, 0, 0, 0)
    zone:registerRegion(6, -460, 8, -500, 0, 0, 0)
    zone:registerRegion(7, -220, 8, -500, 0, 0, 0)
    zone:registerRegion(8, -340, 8,   60, 0, 0, 0)
end

function onInstanceZoneIn(player, instance)
    InstanceOnZoneIn(player, instance, 1)
end

function onRegionEnter(player, region)
end

function onEventUpdate(player, csid, option)
end

function onEventFinish(player, csid, option)
    instanceKickOut(player, csid, 1, dsp.zone.ALZADAAL_UNDERSEA_RUINS)
end

function onInstanceLoadFailed()
    return dsp.zone.ALZADAAL_UNDERSEA_RUINS
end
