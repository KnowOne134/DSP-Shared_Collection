-----------------------------------
-- Uninvited Guests
-- Justinius !pos 78 34 70
-- Monarch Linn
-----------------------------------
require('scripts/globals/interaction/quest')
require('scripts/globals/items')
require('scripts/globals/keyitems')
require('scripts/globals/quests')
require('scripts/globals/missions')
require('scripts/globals/npc_util')
-----------------------------------

function HandleTreasure(player, treasure)
    -- this should be simplified since only one group to pick from ever, but not sure how
    for _, group in ipairs(treasure) do
        for i = 1, group.rolls do
            local rate = 0
            local roll = math.random(1000)
            for key, loot in pairs(group) do
                if key ~= 'rolls' then
                    rate = rate + loot.rate
                    if roll <= rate or rate > 1000 then
                        player:setVar('Quest[4][81]Option', loot.item)
                        break
                    end
                end
            end
        end
    end
end

local quest = Quest:new(xi.quest.log_id.OTHER_AREAS, xi.quest.id.otherAreas.UNINVITED_GUESTS)

quest.reward = {
    title = dsp.title.MONARCH_LINN_PATROL_GUARD,
}

local treasure =
{
    {
        rolls = 1,
        { item = dsp.items.ASSAULT_BREASTPLATE, rate = 1 }, 
        { item = dsp.items.CHUNK_OF_ADAMAN_ORE, rate = 11 }, 
        { item = dsp.items.ADAMANTOISE_SHELL, rate = 2 },
        { item = dsp.items.PAGE_FROM_MIRATETES_MEMOIRS, rate = 537 },
        { item = dsp.items.PIECE_OF_ANGEL_SKIN, rate = 2 },
        { item = dsp.items.BEHEMOTH_HIDE, rate = 9 },
        { item = dsp.items.SERVING_OF_BISON_STEAK, rate = 27 },
        { item = dsp.items.DRAGON_BONE, rate = 16 },
        { item = dsp.items.DRAGON_HEART, rate = 2 },
        { item = dsp.items.ELM_LOG, rate = 16 },
        { item = dsp.items.PIECE_OF_HABU_SKIN, rate = 9 },
        { item = dsp.items.SERVING_OF_MARBLED_STEAK, rate = 2 },
        { item = dsp.items.LEREMIEU_SALAD, rate = 3 },
        { item = dsp.items.PLATE_OF_BREAM_RISOTTO, rate = 34 },
        { item = dsp.items.SERVING_OF_CRIMSON_JELLY, rate = 28 },
        { item = dsp.items.CLOUD_EVOKER, rate = 8 },
        { item = dsp.items.ARMOIRE, rate = 22 },
        { item = dsp.items.MANNEQUIN_BODY, rate = 22 },
        { item = dsp.items.MANNEQUIN_HANDS, rate = 19 },
        { item = dsp.items.MANNEQUIN_HEAD, rate = 6 },
        { item = dsp.items.MANNEQUIN_LEGS, rate = 14 },
        { item = dsp.items.MANNEQUIN_FEET, rate = 13 },
        { item = dsp.items.CHUNK_OF_ORICHALCUM_ORE, rate = 6 },
        { item = dsp.items.SQUARE_OF_RAXA, rate = 30 },
        { item = dsp.items.TIGER_EYE, rate = 27 },
        { item = dsp.items.UNICORN_HORN, rate = 25 },
        { item = dsp.items.BOTTLE_OF_YELLOW_LIQUID, rate = 2 },
        { item = dsp.items.PLATE_OF_WITCH_RISOTTO, rate = 2 },
        { item = dsp.items.BOWL_OF_WITCH_STEW, rate = 1 },
        { item = dsp.items.LOCK_OF_SIRENS_HAIR, rate = 2 },
        { item = dsp.items.SERVING_OF_VERMILLION_JELLY, rate = 6 },
        { item = dsp.items.TAVNAZIAN_SALAD, rate = 28 },
        { item = dsp.items.BOWL_OF_MUSHROOM_STEW, rate = 27 },
        { item = dsp.items.PLATE_OF_MUSHROOM_RISOTTO, rate = 22 },
        { item = dsp.items.OVERSIZED_FANG, rate = 17 },
        { item = dsp.items.PLATE_OF_SEA_SPRAY_RISOTTO, rate = 2 },

    },
}

quest.sections = {

    {
        check = function(player, status, vars)
            return status ~= xi.quest.status.ACCEPTED and os.time() > player:getVar("[ENM]MonarchPatrol")
            and player:hasCompletedMission(COP, THE_SAVAGE)
        end,

        [dsp.zone.TAVNAZIAN_SAFEHOLD] = {
            ['Justinius'] = {
                onTrigger = function(player, npc)
                    if player:getVar("[ENM]MonarchPatrol") == 0 then
                        return quest:progressCutscene(570)
                    else
                        return quest:progressCutscene(573) -- repeat
                    end
                end,
            },

            onEventFinish = {
                [570] = function(player, csid, option, npc)
                    if option == 1 then
                        npcUtil.giveKeyItem(player, dsp.ki.MONARCH_LINN_PATROL_PERMIT)
                        quest:begin(player)
                    end
                end,
                [573] = function(player, csid, option, npc)
                    if option == 1 then
                        player:delQuest(xi.quest.log_id.OTHER_AREAS, xi.quest.id.otherAreas.UNINVITED_GUESTS)
                        npcUtil.giveKeyItem(player, dsp.ki.MONARCH_LINN_PATROL_PERMIT)
                        quest:begin(player)
                    end                    
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED
        end,

        [dsp.zone.TAVNAZIAN_SAFEHOLD] = {
            ['Justinius'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 1 then
                        return quest:progressCutscene(572)
                    elseif quest:getVar(player, 'Stage') == 1 and os.time() > player:getVar("[ENM]MonarchPatrol") then
                        return quest:progressCutscene(574)
                    elseif not player:hasKeyItem(dsp.ki.MONARCH_LINN_PATROL_PERMIT) then
                        return quest:cutscene(575) -- the quest stays active in the log if you fail
                    else
                        return quest:cutscene(571):importantOnce()
                    end
                end,
            },

            onEventFinish = {
                [572] = function(player, csid, option, npc)
                    local reward = quest:getVar(player, 'Option')
                    if reward == 0 then
                        HandleTreasure(player, treasure)
                        if npcUtil.giveItem(player, quest:getVar(player, 'Option')) then
                            quest:complete(player)
                        end
                    else
                        if npcUtil.giveItem(player, reward) then
                            quest:complete(player)
                        end
                    end
                end,
                [574] = function(player, csid, option, npc)
                    quest:setVar(player, 'Stage', 0)
                    npcUtil.giveKeyItem(player, dsp.ki.MONARCH_LINN_PATROL_PERMIT)
                end,
                [575] = function(player, csid, option, npc)
                    if quest:getVar(player, 'Stage') == 0 then
                        quest:setVar(player, 'Stage', 1)
                    end
                end,
            },
        },
    },
}

return quest
