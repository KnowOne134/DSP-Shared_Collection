-----------------------------------
-- Area: Alzadaal Undersea Ruins
-- Door: Gilded Gateway (Arrapago)
-- !pos -580 0 -159 72
-----------------------------------
require("scripts/globals/zone")
require("scripts/globals/utils/salvage")
-----------------------------------

function onTrade(player,npc,trade)
end

function onTrigger(player,npc)
    salvageUtil.onSalvageTrigger(player, npc, 408, 8)
end

function onEventUpdate(player,csid,option,target)
    salvageUtil.onSalvageUpdate(player, csid, option, target, 64, dsp.zone.ARRAPAGO_REMNANTS)
end

function onEventFinish(player,csid,option,target)
    if csid == 408 and option == 4 then
        player:setPos(0, 0, 0, 0, dsp.zone.ARRAPAGO_REMNANTS)
    end
end

function onInstanceCreated(player,target,instance)
    salvageUtil.onInstanceCreated(player, target, instance, 411, 8)
end