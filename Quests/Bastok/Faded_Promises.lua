-----------------------------------
-- Faded Promises
-- Kagetora !pos -96 -2 29 236
-- Ayame    !pos 134 -19 33 237
-- Alois    !pos 97 -20 14 237
-- Romauldo !pos 135 -18 -37 237
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/keyitems")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
-----------------------------------

local quest = Quest:new(xi.quest.log_id.BASTOK, xi.quest.id.bastok.FADED_PROMISES)

quest.reward = {
    title = dsp.title.ASSASSIN_REJECT,
    fame = 30,
    item = dsp.items.FUKURO
}

quest.sections = {

    {
        check = function(player, status, vars)
            return status == xi.quest.status.AVAILABLE and player:getQuestStatus(xi.quest.log_id.BASTOK, xi.quest.id.bastok.AYAME_AND_KAEDE) == xi.quest.status.COMPLETED
            and player:getMainLvl() >= 20 and player:getMainJob() == dsp.job.NIN
        end,

        [dsp.zone.METALWORKS] = {
            ['Romualdo'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Stage') == 0 then
                        return quest:progressEvent(802)
                    end
                end,
            },
            ['Ayame'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Stage') == 1 then
                        return quest:progressEvent(803)
                    end
                end,
            },

            onEventFinish = {
                [802] = function(player, csid, option, npc)
                    quest:setVar(player, 'Stage', 1)
                end,
                [803] = function(player, csid, option, npc)
                    if option == 0 then
                        quest:begin(player)
                        quest:setVar(player, 'Prog', 1)
                        quest:setVar(player, 'Stage', 0)
                    end
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED
        end,

        [dsp.zone.PORT_BASTOK] = {
            ['Kagetora'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 1 and player:hasKeyItem(dsp.ki.DIARY_OF_MUKUNDA) then
                        return quest:progressEvent(296)
                    end
                end,
            },

            onEventFinish = {
                [296] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                    player:delKeyItem(dsp.ki.DIARY_OF_MUKUNDA)
                end,
            },
        },

        [dsp.zone.METALWORKS] = {
            ['Ayame'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 2 then
                        return quest:progressEvent(804)
                    end
                end,
            },
            ['Alois'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 3 then
                        return quest:progressEvent(805)
                    end
                end,
            },

            onEventFinish = {
                [804] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 3)
                end,
                [805] = function(player, csid, option, npc)
                    quest:complete(player)
                end,
            },
        },
    },
}


return quest
