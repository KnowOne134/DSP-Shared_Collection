-----------------------------------
-- Paradise Salvation and Maps
-- tav safehold: Nivorajean
-- Sacrarium chests 
-----------------------------------
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/quests')
require('scripts/globals/interaction/quest')
require('scripts/globals/npc_util')
require('scripts/globals/zone')
-----------------------------------

local quest = Quest:new(xi.quest.log_id.OTHER_AREAS, xi.quest.id.otherAreas.PARADISE_SALVATION_AND_MAPS)
local ID = require("scripts/zones/Sacrarium/IDs")

quest.reward = {
    keyItem = dsp.ki.MAP_OF_THE_SACRARIUM, -- no xp or gil reward in era
}

quest.sections = {
     {
        check = function(player, status, vars)
            return status == xi.quest.status.AVAILABLE
        end,

        [dsp.zone.TAVNAZIAN_SAFEHOLD] = {
            ['Nivorajean'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(223)
                end,
            },
            onEventFinish = {
                [223] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED
        end,



        [dsp.zone.TAVNAZIAN_SAFEHOLD] = {
            ['Nivorajean'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 1 and player:hasKeyItem(dsp.ki.PIECE_OF_RIPPED_FLOORPLANS) then
                        return quest:progressEvent(225, quest:getVar(player, 'Option')) -- return a different menu here based on the location the player got the map in. second param.
                    elseif quest:getVar(player, 'Prog') == 2 and player:hasKeyItem(dsp.ki.PIECE_OF_RIPPED_FLOORPLANS) and quest:getVar(player, 'Stage') <= os.time() then
                        return quest:progressEvent(228)
                    elseif quest:getVar(player, 'Prog') == 0 and player:hasKeyItem(dsp.ki.PIECE_OF_RIPPED_FLOORPLANS) and quest:getVar(player, 'Stage') <= os.time() then
                        return quest:progressEvent(227)
                    elseif quest:getVar(player, 'Prog') == 0 and not player:hasKeyItem(dsp.ki.PIECE_OF_RIPPED_FLOORPLANS) then
                        return quest:event(224) -- failed dialogue, but quest doesnt delete
                    end                
                end,
            },

            onEventFinish = {
                [225] = function(player, csid, option, npc)
                    if option == 0 then
                        quest:setVar(player, 'Stage', getVanaMidnight())
                        quest:setVar(player, 'Prog', 2)
                    else
                        quest:setVar(player, 'Stage', getVanaMidnight())
                        quest:setVar(player, 'Prog', 0)
                    end
                end,
                [227] = function(player, csid, option, npc)
                    player:delKeyItem(dsp.ki.PIECE_OF_RIPPED_FLOORPLANS)
                end,
                [228] = function(player, csid, option, npc)
                    player:delKeyItem(dsp.ki.PIECE_OF_RIPPED_FLOORPLANS)
                    quest:complete(player)
                end,
            },
        },
    },
}

return quest
