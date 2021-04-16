-----------------------------------
--
-- Zone: Zhayolm Remnants
--
-----------------------------------
local ID = require("scripts/zones/Zhayolm_Remnants/IDs")
require("scripts/globals/instance")
require("scripts/globals/zone")
-----------------------------------

function onInitialize(zone)
    zone:registerRegion(1,   420, 5, -340, 0, 0, 0)
    zone:registerRegion(2,   420, 5, -500, 0, 0, 0)
    zone:registerRegion(3,   260, 5, -500, 0, 0, 0)
    zone:registerRegion(4,   260, 5, -340, 0, 0, 0)
    zone:registerRegion(5,   340, 5,  -60, 0, 0, 0)
    zone:registerRegion(6,   340, 5,  420, 0, 0, 0)
    zone:registerRegion(7,   340, 5,  500, 0, 0, 0)
    zone:registerRegion(8,  -380, 5, -620, 0, 0, 0)
    zone:registerRegion(9,  -300, 5, -460, 0, 0, 0)
    zone:registerRegion(10, -340, 5, -100, 0, 0, 0)
    zone:registerRegion(11, -340, 5,  140, 0, 0, 0)
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

function onInstanceLoadFailed()
    return dsp.zone.ALZADAAL_UNDERSEA_RUINS
end
