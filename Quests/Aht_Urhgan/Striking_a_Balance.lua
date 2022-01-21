-----------------------------------
-- Striking a Balance
-- Wazyih  : !pos -94 -6 -93 50
-- Saliyahf : !pos -60 0 65 50
-- Log: 6 Quest: 63
-----------------------------------
require("scripts/globals/items")
require("scripts/globals/keyitems")
require("scripts/globals/quests")
require("scripts/globals/npc_util")
require('scripts/globals/interaction/quest')
-----------------------------------

local quest = Quest:new(xi.quest.log_id.AHT_URHGAN, xi.quest.id.ahtUrhgan.STRIKING_A_BALANCE)

local positionTable =
{
    [1] = { 53,    0,  60},
    [2] = {-70,    6,  40},
    [3] = {-40,    6,  70},
    [4] = { 18,    0, -30},
    [5] = {-13,    0, -40},
    [6] = { 39, -0.5, 116},
    [7] = { 20,    0, -50},
}

quest.reward =
{
    item = {{dsp.items.IMPERIAL_BRONZE_PIECE, 3}},
}

quest.sections =
{

    {
        check = function(player, status, vars)
            return status == xi.quest.status.AVAILABLE
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Wazyih'] =
            {
                onTrigger = function(player, npc)
                    if player:getLocalVar("Quest[6][63]Option") == 0 then
                        return quest:progressEvent(684)
                    else
                        return quest:progressEvent(685)
                    end
                end,
            },
            ['Saliyahf'] = quest:progressEvent(686),

            onEventFinish =
            {
                [684] = function(player, csid, option, npc)
                    player:setLocalVar("Quest[6][63]Option", 1)
                end,
                [686] = function(player, csid, option, npc)
                    player:setLocalVar("Quest[6][63]Option", 0)
                    quest:begin(player)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and
            vars.Prog == 0
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Saliyahf'] = quest:progressEvent(687),
            ['Wazyih'] = quest:progressEvent(688),

            onEventFinish =
            {
                [688] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and
            vars.Prog == 1
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Saliyahf'] = quest:progressEvent(687),
            ['Wazyih'] = quest:progressEvent(689),

            onRegionEnter =
            {
                [11] = function(player, region)
                    return quest:progressEvent(690)
                end,
            },
            onEventFinish =
            {
                [690] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and
            vars.Prog == 2
        end,

        [dsp.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Saliyahf'] =
            {
                onTrigger = function(player, npc)
                    if player:getLocalVar("Quest[6][63]Option") == 0 then
                        return quest:progressEvent(692)
                    else
                        return quest:progressEvent(693)
                    end
                end,
            },
            ['Wazyih'] = quest:progressEvent(691),

            onEventFinish =
            {
                [691] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 3)
                end,

                [692] = function(player, csid, option, npc)
                    player:setLocalVar("Quest[6][63]Option", 1)
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
            ['Saliyahf'] =
            {
                onTrigger = function(player, npc)
                    if player:getLocalVar("Quest[6][63]Option") == 0 then
                        return quest:progressEvent(692)
                    else
                        return quest:progressEvent(693)
                    end
                end,
            },
            ['Wazyih'] = quest:progressEvent(694),

            onEventFinish =
            {
                [692] = function(player, csid, option, npc)
                    player:setLocalVar("Quest[6][63]Option", 1)
                end,
            },
        },
        [dsp.zone.AL_ZAHBI] =
        {
            ['550'] =
            {
                onTrigger = function(player, npc)
                    quest:setVar(player, 'Prog', 4)
                    player:addKeyItem(dsp.ki.MUNAHDAS_PACKAGE)
                    local newPosition = npcUtil.pickNewPosition(npc:getID(), positionTable)
                    npc:setPos(newPosition.x, newPosition.y, newPosition.z)
                    return quest:messageSpecial(zones[player:getZoneID()].text.KEYITEM_OBTAINED, dsp.ki.MUNAHDAS_PACKAGE)
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
            onZoneIn =
            {
                function(player, prevZone)
                    return 695
                end,
            },

            onEventFinish =
            {
                [695] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 5)
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
            ['Saliyahf'] = quest:progressEvent(696),
            ['Wazyih'] = quest:progressEvent(697),

            onEventFinish =
            {
                [696] = function(player, csid, option, npc)
                    if quest:complete(player) then
                        player:delKeyItem(dsp.ki.MUNAHDAS_PACKAGE)
                    end
                end,
            },
        },
    },
}

return quest
