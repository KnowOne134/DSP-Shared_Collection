-----------------------------------
-- A Pose By Any Other Name
-- Angelica !pos -64 -9.25 -9 238
-----------------------------------
require('scripts/globals/items')
require('scripts/globals/quests')
require('scripts/globals/npc/quest')
require('scripts/globals/npc_util')
require('scripts/globals/titles')
-----------------------------------


local quest = Quest:new(WINDURST, A_POSE_BY_ANY_OTHER_NAME)

quest.reward = {
    fame = 75,
    item = dsp.items.COPY_OF_ANCIENT_BLOOD,
    title = dsp.title.SUPER_MODEL,
    keyItem = dsp.ki.ANGELICAS_AUTOGRAPH,
}

quest.sections = {

     {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE and player:needToZone() == false
        end,

        [dsp.zone.WINDURST_WATERS] = {
            ['Angelica'] = {
                onTrigger = function(player, npc)
                    return quest:progressEvent(90)
                end
            },

            onEventFinish = {
                [90] = function(player, csid, option, npc)
                    if option == 1 then
                        quest:begin(player)
                    end
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED and vars.Prog == 0
        end,

        [dsp.zone.WINDURST_WATERS] = {
            ['Angelica'] = {
                onTrigger = function(player, npc)
                    local gear = 0
                    local mjob = player:getMainJob()

                    if mjob == dsp.job.WAR or mjob == dsp.job.PLD or mjob == dsp.job.DRK or mjob == dsp.job.DRG or mjob == dsp.job.COR then
                        gear = dsp.items.BRONZE_HARNESS
                    elseif mjob == dsp.job.MNK or mjob == dsp.job.BRD or mjob == dsp.job.BLU then
                        gear = dsp.items.ROBE
                    elseif mjob == dsp.job.THF or mjob == dsp.job.BST or mjob == dsp.job.RNG or mjob == dsp.job.DNC then
                        gear = dsp.items.LEATHER_VEST
                    elseif mjob == dsp.job.WHM or mjob == dsp.job.BLM or mjob == dsp.job.SMN or mjob == dsp.job.PUP or mjob == dsp.job.SCH or mjob == dsp.job.RDM then
                        gear = dsp.items.TUNIC
                    elseif mjob == dsp.job.SAM or mjob == dsp.job.NIN then
                        gear = dsp.items.KENPOGI
                    end

                    quest:setVar(player, 'Stage', os.time() + 300)
                    quest:setVar(player, 'Prog', gear)

                    return quest:progressEvent(92, {[2] = gear})
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED and vars.Prog ~= 0
        end,

        [dsp.zone.WINDURST_WATERS] = {
            ['Angelica'] = {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Stage') >= os.time() then
                        if player:getEquipID(dsp.slot.BODY) == quest:getVar(player, 'Prog') then
                            return quest:progressEvent(96)
                        else
                            return quest:progressEvent(93, {[2] = quest:getVar(player, 'Prog')})
                        end
                    else
                        return quest:progressEvent(102)
                    end
                end,
            },

            onEventFinish = {
                [96] = function(player, csid, option, npc)
                    quest:complete(player)
                end,
                [102] = function(player, csid, option, npc)
                    player:delQuest(WINDURST, A_POSE_BY_ANY_OTHER_NAME)
                    quest:setVar(player, 'Prog', 0)
                    quest:setVar(player, 'Stage', 0)
                    player:addTitle(dsp.title.LOWER_THAN_THE_LOWEST_TUNNEL_WORM)
                    player:needToZone(true)
                end,
            },
        },
    },
}

return quest
