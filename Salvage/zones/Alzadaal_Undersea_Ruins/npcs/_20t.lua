-----------------------------------
-- Area: Alzadaal Undersea Ruins
-- Door: Gilded Gateway (Silver Sea)
-- !pos 580 -2 442 72
-----------------------------------
require("scripts/globals/zone")
require("scripts/globals/utils/salvage")
-----------------------------------

function onTrade(player,npc,trade)
end

function onTrigger(player,npc)
    salvageUtil.onSalvageTrigger(player, npc, 410, 10)
end

function onEventUpdate(player,csid,option,target)
    salvageUtil.onSalvageUpdate(player, csid, option, target, 70, dsp.zone.SILVER_SEA_REMNANTS)
end

function onEventFinish(player,csid,option,target)
    if csid == 410 and option == 4 then
        player:setPos(0, 0, 0, 0, dsp.zone.SILVER_SEA_REMNANTS)
    end
end

function onInstanceCreated(player,target,instance)
    salvageUtil.onInstanceCreated(player, target, instance, 411, 10)
end
