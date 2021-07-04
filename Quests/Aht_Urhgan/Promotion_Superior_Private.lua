-----------------------------------
-- Promotion: Superior Private
-- Naja Salaheem !pos 26 -8 -45.5 50
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
-----------------------------------

local quest = Quest:new(AHT_URHGAN, PROMOTION_SUPERIOR_PRIVATE)

quest.reward = {
    keyItem = dsp.ki.SP_WILDCAT_BADGE,
}

quest.sections = {
    -- Section: Begin quest
    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE and player:getVar("AssaultPromotion") >= 25
            and player:getQuestStatus(AHT_URHGAN, PROMOTION_PRIVATE_FIRST_CLASS) == QUEST_COMPLETED
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] = {
            ['Naja_Salaheem'] = quest:progressEvent(5020, { text_table = 0 }),

            onEventFinish = {
                [5020] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED and not player:hasKeyItem(dsp.ki.DARK_RIDER_HOOFPRINT)
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] = {
            ['Naja_Salaheem'] = quest:event(5021, { text_table = 0 }),
        },

        [dsp.zone.BHAFLAU_THICKETS] = {
            ['Warhorse_Hoofprint'] = quest:keyItem(dsp.ki.DARK_RIDER_HOOFPRINT)
        },
        [dsp.zone.CAEDARVA_MIRE] = {
            ['Warhorse_Hoofprint'] = quest:keyItem(dsp.ki.DARK_RIDER_HOOFPRINT)
        },
        [dsp.zone.MOUNT_ZHAYOLM] = {
            ['Warhorse_Hoofprint'] = quest:keyItem(dsp.ki.DARK_RIDER_HOOFPRINT)
        },
        [dsp.zone.WAJAOM_WOODLANDS] = {
            ['Warhorse_Hoofprint'] = quest:keyItem(dsp.ki.DARK_RIDER_HOOFPRINT)
        },

    },
    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED and player:hasKeyItem(dsp.ki.DARK_RIDER_HOOFPRINT)
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] = {
            ['Naja_Salaheem'] = quest:progressEvent(5022, { text_table = 0 }),

            onEventFinish = {
                [5022] = function(player, csid, option, npc)
                    if quest:complete(player) then
                        player:setVar("AssaultPromotion", 0)
                    end
                end,
            },
        },
    },
}

return quest
