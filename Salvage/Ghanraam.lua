-----------------------------------
-- Area: Aht Urhgan Whitegate
--  NPC: Ghanraam
-- Type: "Nyzul Weapon/Salvage Armor Storer"
-- !pos 108.773 -6.999 -51.297 50
-----------------------------------
local ID = require("scripts/zones/Aht_Urhgan_Whitegate/IDs")
require("scripts/globals/common")
require("scripts/globals/items")
require("scripts/globals/npc_util")
require("scripts/globals/utils")
-----------------------------------

local sets = {1, 1, 2, 2, 3, 3, 4, 4, 5, 5} -- set armorType for player (1 Areas, 2 Skadi, 3 Usukane, 4 Marduk, 5 Morg)
local vigilWeapons =
{
    [0]  = dsp.items.STURDY_AXE,
    [1]  = dsp.items.BURNING_FISTS,
    [2]  = dsp.items.WEREBUSTER,
    [3]  = dsp.items.MAGES_STAFF,
    [4]  = dsp.items.VORPAL_SWORD,
    [5]  = dsp.items.SWORDBREAKER,
    [6]  = dsp.items.BRAVE_BLADE,
    [7]  = dsp.items.DEATH_SICKLE,
    [8]  = dsp.items.DOUBLE_AXE,
    [9]  = dsp.items.DANCING_DAGGER,
    [10] = dsp.items.KILLER_BOW,
    [11] = dsp.items.WINDSLICER,
    [12] = dsp.items.SASUKE_KATANA,
    [13] = dsp.items.RADIANT_LANCE,
    [14] = dsp.items.SCEPTER_STAFF,
    [15] = dsp.items.WIGHTSLAYER,
    [16] = dsp.items.QUICKSILVER,
    [17] = dsp.items.INFERNO_CLAWS,
    [18] = dsp.items.MAIN_GAUCHE,
    [19] = dsp.items.ELDER_STAFF,
}
local salvageArmor =
{
    [1] =
    {
        {item = dsp.items.ENYOS_MASK,        part = 1, reward = dsp.items.ARES_MASK},
        {item = dsp.items.PHOBOSS_MASK,      part = 1, reward = dsp.items.ARES_MASK},
        {item = dsp.items.DEIMOSS_MASK,      part = 1, reward = dsp.items.ARES_MASK},
        {item = dsp.items.ENYOS_BREASTPLATE, part = 2, reward = dsp.items.ARES_CUIRASS},
        {item = dsp.items.PHOBOSS_CUIRASS,   part = 2, reward = dsp.items.ARES_CUIRASS},
        {item = dsp.items.DEIMOSS_CUIRASS,   part = 2, reward = dsp.items.ARES_CUIRASS},
        {item = dsp.items.ENYOS_GAUNTLETS,   part = 3, reward = dsp.items.ARES_GAUNTLETS},
        {item = dsp.items.PHOBOSS_GAUNTLETS, part = 3, reward = dsp.items.ARES_GAUNTLETS},
        {item = dsp.items.DEIMOSS_GAUNTLETS, part = 3, reward = dsp.items.ARES_GAUNTLETS},
        {item = dsp.items.ENYOS_CUISSES,     part = 4, reward = dsp.items.ARES_FLANCHARD},
        {item = dsp.items.PHOBOSS_CUISSES,   part = 4, reward = dsp.items.ARES_FLANCHARD},
        {item = dsp.items.DEIMOSS_CUISSES,   part = 4, reward = dsp.items.ARES_FLANCHARD},
        {item = dsp.items.ENYOS_LEGGINGS,    part = 5, reward = dsp.items.ARES_SOLLERETS},
        {item = dsp.items.PHOBOSS_SABATONS,  part = 5, reward = dsp.items.ARES_SOLLERETS},
        {item = dsp.items.DEIMOSS_LEGGINGS,  part = 5, reward = dsp.items.ARES_SOLLERETS},
    },
    [2] =
    {
        {item = dsp.items.NJORDS_MASK,      part = 1, reward = dsp.items.SKADIS_VISOR},
        {item = dsp.items.FREYRS_MASK,      part = 1, reward = dsp.items.SKADIS_VISOR},
        {item = dsp.items.FREYAS_MASK,      part = 1, reward = dsp.items.SKADIS_VISOR},
        {item = dsp.items.NJORDS_JERKIN,    part = 2, reward = dsp.items.SKADIS_CUIRIE},
        {item = dsp.items.FREYRS_JERKIN,    part = 2, reward = dsp.items.SKADIS_CUIRIE},
        {item = dsp.items.FREYAS_JERKIN,    part = 2, reward = dsp.items.SKADIS_CUIRIE},
        {item = dsp.items.NJORDS_GLOVES,    part = 3, reward = dsp.items.SKADIS_BAZUBANDS},
        {item = dsp.items.FREYRS_GLOVES,    part = 3, reward = dsp.items.SKADIS_BAZUBANDS},
        {item = dsp.items.FREYAS_GLOVES,    part = 3, reward = dsp.items.SKADIS_BAZUBANDS},
        {item = dsp.items.NJORDS_TROUSERS,  part = 4, reward = dsp.items.SKADIS_CHAUSSES},
        {item = dsp.items.FREYRS_TROUSERS,  part = 4, reward = dsp.items.SKADIS_CHAUSSES},
        {item = dsp.items.FREYAS_TROUSERS,  part = 4, reward = dsp.items.SKADIS_CHAUSSES},
        {item = dsp.items.NJORDS_LEDELSENS, part = 5, reward = dsp.items.SKADIS_JAMBEAUX},
        {item = dsp.items.FREYRS_LEDELSENS, part = 5, reward = dsp.items.SKADIS_JAMBEAUX},
        {item = dsp.items.FREYAS_LEDELSENS, part = 5, reward = dsp.items.SKADIS_JAMBEAUX},
    },
    [3] =
    {
        {item = dsp.items.HOSHIKAZU_HACHIMAKI, part = 1, reward = dsp.items.USUKANE_SOMEN},
        {item = dsp.items.TSUKIKAZU_JINPACHI,  part = 1, reward = dsp.items.USUKANE_SOMEN},
        {item = dsp.items.HIKAZU_KABUTO,       part = 1, reward = dsp.items.USUKANE_SOMEN},
        {item = dsp.items.HOSHIKAZU_GI,        part = 2, reward = dsp.items.USUKANE_HARAMAKI},
        {item = dsp.items.TSUKIKAZU_TOGI,      part = 2, reward = dsp.items.USUKANE_HARAMAKI},
        {item = dsp.items.HIKAZU_HARA_ATE,     part = 2, reward = dsp.items.USUKANE_HARAMAKI},
        {item = dsp.items.HOSHIKAZU_TEKKO,     part = 3, reward = dsp.items.USUKANE_GOTE},
        {item = dsp.items.TSUKIKAZU_GOTE,      part = 3, reward = dsp.items.USUKANE_GOTE},
        {item = dsp.items.HIKAZU_GOTE,         part = 3, reward = dsp.items.USUKANE_GOTE},
        {item = dsp.items.HOSHIKAZU_HAKAMA,    part = 4, reward = dsp.items.USUKANE_HIZAYOROI},
        {item = dsp.items.TSUKIKAZU_HAIDATE,   part = 4, reward = dsp.items.USUKANE_HIZAYOROI},
        {item = dsp.items.HIKAZU_HAKAMA,       part = 4, reward = dsp.items.USUKANE_HIZAYOROI},
        {item = dsp.items.HOSHIKAZU_KYAHAN,    part = 5, reward = dsp.items.USUKANE_SUNE_ATE},
        {item = dsp.items.TSUKIKAZU_SUNE_ATE,  part = 5, reward = dsp.items.USUKANE_SUNE_ATE},
        {item = dsp.items.HIKAZU_SUNE_ATE,     part = 5, reward = dsp.items.USUKANE_SUNE_ATE},
    },
    [4] =
    {
        {item = dsp.items.ANUS_TIARA,       part = 1, reward = dsp.items.MARDUKS_TIARA},
        {item = dsp.items.EAS_TIARA,        part = 1, reward = dsp.items.MARDUKS_TIARA},
        {item = dsp.items.ENLILS_TIARA,     part = 1, reward = dsp.items.MARDUKS_TIARA},
        {item = dsp.items.ANUS_DOUBLET,     part = 2, reward = dsp.items.MARDUKS_JUBBAH},
        {item = dsp.items.EAS_DOUBLET,      part = 2, reward = dsp.items.MARDUKS_JUBBAH},
        {item = dsp.items.ENLILS_GAMBISON,  part = 2, reward = dsp.items.MARDUKS_JUBBAH},
        {item = dsp.items.ANUS_GAGES,       part = 3, reward = dsp.items.MARDUKS_DASTANAS},
        {item = dsp.items.EAS_DASTANAS,     part = 3, reward = dsp.items.MARDUKS_DASTANAS},
        {item = dsp.items.ENLILS_KOLLUKS,   part = 3, reward = dsp.items.MARDUKS_DASTANAS},
        {item = dsp.items.ANUS_BRAIS,       part = 4, reward = dsp.items.MARDUKS_SHALWAR},
        {item = dsp.items.EAS_BRAIS,        part = 4, reward = dsp.items.MARDUKS_SHALWAR},
        {item = dsp.items.ENLILS_BRAYETTES, part = 4, reward = dsp.items.MARDUKS_SHALWAR},
        {item = dsp.items.ANUS_GAITERS,     part = 5, reward = dsp.items.MARDUKS_CRACKOWS},
        {item = dsp.items.EAS_CRACKOWS,     part = 5, reward = dsp.items.MARDUKS_CRACKOWS},
        {item = dsp.items.ENLILS_CRACKOWS,  part = 5, reward = dsp.items.MARDUKS_CRACKOWS},
    },
    [5] =
    {
        {item = dsp.items.NEMAINS_CROWN,   part = 1, reward = dsp.items.MORRIGANS_CORONAL},
        {item = dsp.items.BODBS_CROWN,     part = 1, reward = dsp.items.MORRIGANS_CORONAL},
        {item = dsp.items.MACHAS_CROWN,    part = 1, reward = dsp.items.MORRIGANS_CORONAL},
        {item = dsp.items.NEMAINS_ROBE,    part = 2, reward = dsp.items.MORRIGANS_ROBE},
        {item = dsp.items.BODBS_ROBE,      part = 2, reward = dsp.items.MORRIGANS_ROBE},
        {item = dsp.items.MACHAS_COAT,     part = 2, reward = dsp.items.MORRIGANS_ROBE},
        {item = dsp.items.NEMAINS_CUFFS,   part = 3, reward = dsp.items.MORRIGANS_CUFFS},
        {item = dsp.items.BODBS_CUFFS,     part = 3, reward = dsp.items.MORRIGANS_CUFFS},
        {item = dsp.items.MACHAS_CUFFS,    part = 3, reward = dsp.items.MORRIGANS_CUFFS},
        {item = dsp.items.NEMAINS_SLOPS,   part = 4, reward = dsp.items.MORRIGANS_SLOPS},
        {item = dsp.items.BODBS_SLOPS,     part = 4, reward = dsp.items.MORRIGANS_SLOPS},
        {item = dsp.items.MACHAS_SLOPS,    part = 4, reward = dsp.items.MORRIGANS_SLOPS},
        {item = dsp.items.NEMAINS_SABOTS,  part = 5, reward = dsp.items.MORRIGANS_PIGACHES},
        {item = dsp.items.BODBS_PIGACHES,  part = 5, reward = dsp.items.MORRIGANS_PIGACHES},
        {item = dsp.items.MACHAS_PIGACHES, part = 5, reward = dsp.items.MORRIGANS_PIGACHES},
    }
}

local finishedCurrency =
{
    [1] = dsp.items.ORICHALCUM_INGOT,
    [2] = dsp.items.IMPERIAL_WOOTZ_INGOT,
    [3] = dsp.items.PIECE_OF_BLOODWOOD_LUMBER,
    [4] = dsp.items.SQUARE_OF_WAMOURA_CLOTH,
    [5] = dsp.items.SQUARE_OF_MARID_LEATHER,
}

function onTrade(player, npc, trade)
    for weaponBit, weapon in pairs(vigilWeapons) do
        if npcUtil.tradeHas(trade, weapon) then
            local param = 12 -- 9 Vigil Weapons full, 10 duplicate weapon in storage, 11 store weapon, 12 weapon traded with no fee
            if trade:hasItemQty(dsp.items.IMPERIAL_BRONZE_PIECE, 1) then --and trade:getItemCount() == 2 then
                if player:getVar("vigilWeaponStored") == 1048575 then
                    param = 9
                elseif utils.isBitSet(player:getVar("vigilWeaponStored"), weaponBit) then
                    param = 10
                else
                    param = 11
                    player:setVar("vigilWeaponStored", utils.setBit(player:getVar("vigilWeaponStored"), weaponBit, 1))
                    player:confirmTrade()
                    player:delItem(dsp.items.IMPERIAL_BRONZE_PIECE, 1)
                end
            end
            player:startEvent(816, {[2] = param})
            break
        end
    end
    local armorType = player:getVar("salvageArmorSet") -- 0 Ares, 1 Skadi, 2 Usukane, 3 Marduk, 4 Morg
    if armorType > 0 then
        for armorBit, armor in pairs(salvageArmor[armorType]) do
            local partsCollected = 0
            local bodyPiece = 1
            local storedArmor = player:getVar("salvageArmorStored")
            local storedBits = utils.splitBits(storedArmor, 3) or 0
            if npcUtil.tradeHas(trade, armor.item) then
                if storedArmor == 32767 then -- has every piece stored
                    partsCollected = 7
                elseif utils.isBitSet(storedArmor, armorBit - 1) then -- has stored item already
                    partsCollected = 6
                elseif player:hasItem(armor.reward) then -- has a completed item
                    partsCollected = 8
                else
                    player:setVar("salvageArmorStored", utils.setBit(player:getVar("salvageArmorStored"), armorBit - 1, 1))
                    bodyPiece = armor.part -- 0 Head, 1 Body, 2 Hands, 3 Legs, 4 Feet
                    partsCollected = 1 + (utils.countSetBits(storedBits[bodyPiece]) or 0)
                    player:confirmTrade()
                    player:PrintToPlayer(string.format("%s", partsCollected))
                end
                player:startEvent(816, {[0] = armorType -1, [1] = bodyPiece - 1, [2] = partsCollected})
                break
            end
        end
    end
    if player:getVar("salvageReward") == 0 then
        for armorSet, items in pairs(finishedCurrency) do
            local storedArmor = player:getVar("salvageArmorStored")
            local armorBits = utils.splitBits(storedArmor, 3)
            local storedArmor = player:getVar("salvageArmorStored")
            if npcUtil.tradeHasExactly(trade, {{items, 12},{dsp.items.IMPERIAL_GOLD_PIECE, 10}}) and armorBits[armorSet] == 7 then
                player:confirmTrade()
                player:startEvent(816, {[0] = armorType -1, [1] = armorSet - 1, [2] = 5})
                player:setVar("salvageReward", salvageArmor[player:getVar("salvageArmorSet")][armorSet * 3].reward)
                player:setVar("salvageRewardTime", getMidnight())
                for rank = 1,3 do
                    player:setVar("salvageArmorStored", utils.setBit(player:getVar("salvageArmorStored"), armorSet * 3 - rank, 0))
                end
            end
        end
    end
end

function onTrigger(player, npc)
    if player:getVar("[Ghanraam]salvageTalk") == 1 then
        player:startEvent(814)
    elseif player:getVar("[Ghanraam]salvageTalk") == 2 then
        player:startEvent(893)
    elseif player:getVar("salvageReward") > 0 and player:needToZone() == false then
        if player:getVar("salvageRewardTime") < os.time() then
            player:messageSpecial(ID.text.SALVAGE_REWARD)
            if npcUtil.giveItem(player, player:getVar("salvageReward")) then
                player:setVar("salvageReward", 0)
                player:setVar("salvageRewardTime", 0)
            end
        else
            player:messageSpecial(ID.text.SALVAGE_REWARD_WAIT)
            player:needToZone(true)
        end
    end
end

function onEventUpdate(player, csid, option)
    if csid == 815 then
        if option == 11 then -- armor returns
            local storedArmor = player:getVar("salvageArmorStored")
            local pageBits = utils.splitBits(storedArmor, 8)
            local armorType = player:getVar("salvageArmorSet") -- 1 Areas, 2 Skadi, 3 Usukane, 4 Marduk, 5 Morg
            local firstpage = pageBits[1] -- in bits 8 bits 255 total (1st 3 heads, 2nd 3 body, 3rd 2 hands)
            local secondPage = pageBits[2] -- in bits 1st 1 hands, 2nd 3 legs, 3rd 3 feet
            local storedArmor = storedArmor > 0 and 1 or 0 -- 0 if none stored, 1 if have
            player:updateEvent(firstpage,secondPage,armorType,storedArmor)
        elseif option == 27 then -- weapon returns
            local storedWeapons = player:getVar("vigilWeaponStored")
            local pageBits = utils.splitBits(storedWeapons, 8)
            local firstpage = pageBits[1] -- 255
            local secondPage = pageBits[2] -- 255
            local thirdPage = pageBits[3] -- 15
            local weaponStored = storedWeapons > 0 and 1 or 0 -- 0 no weapons stored, 1 if have
            player:updateEvent(firstpage,secondPage,thirdPage,weaponStored)
        elseif option <= 10 then -- changing sets
            if option == 1 or option == 3 or option == 5 or option == 7 or option == 9 then
                local currentSet = player:getVar("salvageArmorSet")
                player:updateEvent(currentSet - 1, currentSet)
            else
                if player:getVar("salvageArmorStored") ~= 0 then
                    player:messageSpecial(ID.text.HERE_IS_YOUR_ARMOR)
                    local itemID = 0
                    local set = player:getVar("salvageArmorSet")
                    for i = 0, 14 do
                        if utils.isBitSet(player:getVar("salvageArmorStored"), i) then
                            itemID = salvageArmor[set][i + 1].item
                            if not player:hasItem(itemID) and player:getFreeSlotsCount() > 0 then
                                player:addItem(itemID)
                                player:messageSpecial(ID.text.GHANRAAM_RETURNS, itemID)
                                player:setVar("salvageArmorStored",utils.setBit(player:getVar("salvageArmorStored"), i, 0))
                            else
                                player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, itemID)
                                player:updateEvent(1,1)
                                return
                            end
                        end
                    end
                end
                if player:getVar("salvageArmorStored") == 0 then
                    player:updateEvent(3)
                end
            end
        elseif option > 27 and option < 48 then -- retrieving a weapon
            if npcUtil.giveItem(player, vigilWeapons[option - 28]) then
                for weaponBit, v in pairs(vigilWeapons) do
                    if option - 28 == weaponBit then
                        player:setVar("vigilWeaponStored",utils.setBit(player:getVar("vigilWeaponStored"), weaponBit, 0))
                        break
                    end
                end
            end
        elseif option > 11 and option < 27 then -- retrieving armor
            if npcUtil.giveItem(player, salvageArmor[player:getVar("salvageArmorSet")][option - 11].item) then
                for armorBit, v in pairs(salvageArmor[player:getVar("salvageArmorSet")]) do
                    if option - 11 == armorBit then
                        player:setVar("salvageArmorStored",utils.setBit(player:getVar("salvageArmorStored"), armorBit - 1, 0))
                        break
                    end
                end
            end
        end
    end
end

function onEventFinish(player, csid, option)
    if csid == 814 then
        player:setVar("[Ghanraam]salvageTalk", 2)
    elseif csid == 893 then
        player:setVar("[Ghanraam]salvageTalk", 0)
    end
    if option <= 10 and option ~= 0 then
        for armorSet, chosenSet in pairs(sets) do
            if armorSet == option then
                player:setVar("salvageArmorSet", chosenSet)
                break
            end
        end
    end
end