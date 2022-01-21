-----------------------------------
-- Embers of His Past
-- Fari-Wari          : !pos 80 -6 -137 50
-- Sprightly Footsteps: !pos 822 -18 176 61
-- Withered Petals    : !pos 857 -14 248 61
-- Logid 6 Questid 48
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
-----------------------------------

local quest = Quest:new(xi.quest.log_id.AHT_URHGAN, xi.quest.id.ahtUrhgan.EMBERS_OF_HIS_PAST)

quest.reward =
{
    item = dsp.items.IMPERIAL_GOLD_PIECE,
}

quest.sections =
{

    {
        check = function(player, status, vars)
            return status == xi.quest.status.AVAILABLE and
            player:getQuestStatus(xi.quest.log_id.AHT_URHGAN, xi.quest.id.ahtUrhgan.SOOTHING_WATERS) == xi.quest.status.COMPLETED
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Fari-Wari'] = quest:progressEvent(916, {text_table = 0}),

            onEventFinish =
            {
                [916] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                    quest:begin(player)
                    player:setPos(0, 0, 0, 0, dsp.zone.WAJAOM_WOODLANDS)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and
            vars.Prog == 1
        end,

        [dsp.zone.WAJAOM_WOODLANDS] =
        {
            onZoneIn =
            {
                function(player, prevZone)
                    return 16
                end,
            },

            onEventFinish =
            {
                [16] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                    player:setPos(0, 0, 0, 0, dsp.zone.WAJAOM_WOODLANDS, true)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and
            vars.Prog == 2
        end,

        [dsp.zone.WAJAOM_WOODLANDS] =
        {
            onZoneIn =
            {
                function(player, prevZone)
                    return 17
                end,
            },

            onEventFinish =
            {
                [17] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 3)
                    player:setPos(80, -6, -123, 55, dsp.zone.AHT_URHGAN_WHITEGATE)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and
            vars.Prog == 3
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Fari-Wari'] = quest:progressEvent(917),
        },

        [dsp.zone.MOUNT_ZHAYOLM] =
        {
            ['SprightlyFoots'] =
            {
                onTrigger = function(player, npc)
                    if VanadielHour() >= 18 or VanadielHour() <= 6 then
                        return quest:progressCutscene(15)
                    end
                end,
            },

            onEventFinish =
            {
                [15] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 4)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and
            vars.Prog == 4
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Fari-Wari'] = quest:progressEvent(917),
        },

        [dsp.zone.MOUNT_ZHAYOLM] =
        {
            ['WitheredPetals'] =
            {
                onTrigger = function(player, npc)
                    if VanadielHour() >= 18 or VanadielHour() <= 6 then
                        return quest:progressCutscene(16)
                    end
                end,
            },

            onEventFinish =
            {
                [16] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 5)
                    player:setPos(141.740, -2, 0, 132, dsp.zone.AHT_URHGAN_WHITEGATE)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and
            vars.Prog == 5
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Fari-Wari'] =
            {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, dsp.items.HYDRANGEA) then
                        return quest:progressEvent(918, {text_table = 0})
                    end
                end,

                onTrigger = function(player, npc)
                    return quest:progressEvent(924)
                end,
            },
            onEventFinish =
            {
                [918] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 6)
                    player:setPos(0, 0, 0, 0, dsp.zone.WAJAOM_WOODLANDS)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and
            vars.Prog == 6
        end,

        [dsp.zone.WAJAOM_WOODLANDS] =
        {
            onZoneIn =
            {
                function(player, prevZone)
                    return 18
                end,
            },

            onEventFinish =
            {
                [18] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 7)
                    player:setPos(0, 0, 0, 0, dsp.zone.WAJAOM_WOODLANDS, true)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and
            vars.Prog == 7
        end,

        [dsp.zone.WAJAOM_WOODLANDS] =
        {
            onZoneIn =
            {
                function(player, prevZone)
                    return 19
                end,
            },

            onEventFinish =
            {
                [19] = function(player, csid, option, npc)
                    player:messageSpecial(zones[player:getZoneID()].text.ITEM_RETURNED, dsp.items.HYDRANGEA)
                    quest:setVar(player, 'Prog', 8)
                    player:timer(1000, function(player) player:setPos(80, -6, -123, 55, dsp.zone.AHT_URHGAN_WHITEGATE) end)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and
            vars.Prog == 8
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Fari-Wari'] = quest:progressEvent(919),
        },

        [dsp.zone.MOUNT_ZHAYOLM] =
        {
            ['WitheredPetals'] =
            {
                onTrade = function(player, npc, trade)
                    if VanadielHour() >= 18 or VanadielHour() <= 6 then
                        if npcUtil.tradeHasExactly(trade, dsp.items.HYDRANGEA) then
                            return quest:progressCutscene(17)
                        end
                    end
                end,
            },

            onEventFinish =
            {
                [17] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 9)
                    player:confirmTrade()
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and
            vars.Prog == 9
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Fari-Wari'] = quest:progressEvent(920, {text_table = 0}),

            onEventFinish =
            {
                [920] = function(player, csid, option, npc)
                    if quest:complete(player) then
                        player:addCurrency("imperial_standing", 500)
                        player:messageSpecial(zones[player:getZoneID()].text.BESIEGED_OFFSET)
                    end
                end,
            },
        },
    },
}


return quest
