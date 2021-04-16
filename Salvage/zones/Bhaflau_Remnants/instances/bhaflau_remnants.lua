-----------------------------------
--
-- Salvage: Bhaflau Remnants
--
-----------------------------------
local ID = require("scripts/zones/Bhaflau_Remnants/IDs")
require("scripts/globals/instance")
require("scripts/globals/items")
require("scripts/globals/utils/salvage")
-----------------------------------

function afterInstanceRegister(player)
    salvageUtil.afterInstanceRegister(player, ID.text, dsp.items.CAGE_OF_B_REMNANTS_FIREFLIES)
end

function onInstanceCreated(instance)
    instance:setStage(1)
    instance:setProgress(0)
end

function onInstanceTimeUpdate(instance, elapsed)
    updateInstanceTime(instance, elapsed, ID.text)
end

function onInstanceFailure(instance)
    local chars = instance:getChars()

    for _, players in pairs(chars) do
        players:messageSpecial(ID.text.MISSION_FAILED, 10, 10)
        players:startCutscene(1)
    end
end

function onInstanceComplete(instance)
end

function onRegionEnter(player, region, instance)
    local regionID = region:GetRegionID()

    if regionID <= 8 then
        player:startCutscene(199 + regionID)
    end
end

function onInstanceProgressUpdate(instance, progress, elapsed)
end

function onEventUpdate(player, csid, option)
    local instance = player:getInstance()

    if csid ~= 3 then
        salvageUtil.deSpawnStage(player)
        salvageUtil.resetTempBoxes(player)
    end
    if option ==1 then
        if csid == 200 then
            instance:setStage(2)
            instance:setProgress(0)
            salvageUtil.unsealDoors(player, ID.npc[2].EAST_ENTRANCE)
            salvageUtil.unsealDoors(player, ID.npc[2].WEST_ENTRANCE)
        elseif csid >= 201 and csid <= 204 then
            instance:setStage(3)
            instance:setProgress(csid - 200)
        elseif csid >= 205 and csid <= 206 then
            instance:setStage(4)
            instance:setProgress(csid - 204)
        elseif csid == 207 then
            instance:setStage(5)
            instance:setProgress(0)
            salvageUtil.unsealDoors(player, ID.npc[5].DOOR1)
        end
    end
end

function onEventFinish(player, csid, option)
    local instance = player:getInstance()

    if option == 1 then
        if csid >= 200 and csid <= 207 then
            salvageUtil.teleportGroup(player)
            salvageUtil.spawnStage(player)
        end
    end
end