-----------------------------------
-- Assault SP rank-up quest

-- Naja Salaheem !pos 26 -8 -45.5 50
-----------------------------------
require("scripts/globals/common")
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/hidden_quest')
-----------------------------------

local quest = HiddenQuest:new("AssaultRank_SP")

quest.reward = {
    keyItem = dsp.ki.SP_WILDCAT_BADGE,
}

quest.sections = {
    -- Section: Begin quest
    {
        check = function(player, questVars, vars)
            return player:hasKeyItem(dsp.ki.PFC_WILDCAT_BADGE)
                and not player:hasKeyItem(dsp.ki.SP_WILDCAT_BADGE)
                and vars['AssaultPromotion'] >= 25
                and questVars.Prog == 0
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] = {
            ['Naja_Salaheem'] = quest:progressEvent(5020, { text_table = 0 }),

            onEventFinish = {
                [5020] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
            },
        },
    },

    -- Section: Hoofprint hunting
    {
        check = function(player, questVars, vars)
            return not player:hasKeyItem(dsp.ki.DARK_RIDER_HOOFPRINT) and questVars.Prog == 1
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

    -- Section: Finish quest
    {
        check = function(player, questVars, vars)
            return player:hasKeyItem(dsp.ki.DARK_RIDER_HOOFPRINT) and questVars.Prog == 1
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
