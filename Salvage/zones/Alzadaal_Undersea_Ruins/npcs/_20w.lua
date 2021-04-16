-----------------------------------
-- Area: Alzadaal Undersea Ruins
-- Door: Gilded Gateway (Bhaflau)
-- !pos 620 -2 -202 72
-----------------------------------
require("scripts/globals/zone")
require("scripts/globals/utils/salvage")
-----------------------------------

function onTrade(player,npc,trade)
end

function onTrigger(player,npc)
    salvageUtil.onSalvageTrigger(player, npc, 409, 9)
end

function onEventUpdate(player,csid,option,target)
    salvageUtil.onSalvageUpdate(player, csid, option, target, 67, dsp.zone.BHAFLAU_REMNANTS)
end

function onEventFinish(player,csid,option,target)
    if csid == 409 and option == 4 then
        player:setPos(0, 0, 0, 0, dsp.zone.BHAFLAU_REMNANTS)
    end
end

function onInstanceCreated(player,target,instance)
    salvageUtil.onInstanceCreated(player, target, instance, 411, 9)
end
