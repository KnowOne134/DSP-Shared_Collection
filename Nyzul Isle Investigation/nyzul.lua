-----------------------------------
-- Nyzul Isle Global
-----------------------------------
local ID = require("scripts/zones/Nyzul_Isle/IDs")
require("scripts/globals/items")
require("scripts/globals/settings")
require("scripts/globals/status")
require("scripts/globals/utils")
require("scripts/globals/utils/appraisal")
require("scripts/globals/zone")
-----------------------------------

nyzul = nyzul or {}

nyzul.baseWeapons =
{
    [dsp.job.WAR] = dsp.items.STURDY_AXE,
    [dsp.job.MNK] = dsp.items.BURNING_FISTS,
    [dsp.job.WHM] = dsp.items.WEREBUSTER,
    [dsp.job.BLM] = dsp.items.MAGES_STAFF,
    [dsp.job.RDM] = dsp.items.VORPAL_SWORD,
    [dsp.job.THF] = dsp.items.SWORDBREAKER,
    [dsp.job.PLD] = dsp.items.BRAVE_BLADE,
    [dsp.job.DRK] = dsp.items.DEATH_SICKLE,
    [dsp.job.BST] = dsp.items.DOUBLE_AXE,
    [dsp.job.BRD] = dsp.items.DANCING_DAGGER,
    [dsp.job.RNG] = dsp.items.KILLER_BOW,
    [dsp.job.SAM] = dsp.items.WINDSLICER,
    [dsp.job.NIN] = dsp.items.SASUKE_KATANA,
    [dsp.job.DRG] = dsp.items.RADIANT_LANCE,
    [dsp.job.SMN] = dsp.items.SCEPTER_STAFF,
    [dsp.job.BLU] = dsp.items.WIGHTSLAYER,
    [dsp.job.COR] = dsp.items.QUICKSILVER,
    [dsp.job.PUP] = dsp.items.INFERNO_CLAWS,
--  [dsp.job.DNC] = dsp.items.MAIN_GAUCHE,
--  [dsp.job.SCH] = dsp.items.ELDER_STAFF,
}

nyzul.objective =
{
    ELIMINATE_ENEMY_LEADER        = 0,
    ELIMINATE_SPECIFIED_ENEMIES   = 1,
    ACTIVATE_ALL_LAMPS            = 2,
    ELIMINATE_SPECIFIED_ENEMY     = 3,
    ELIMINATE_ALL_ENEMIES         = 4,
    FREE_FLOOR                    = 5,
}

nyzul.lampsObjective =
{
    REGISTER     = 1,
    ACTIVATE_ALL = 2,
    ORDER        = 3,
}

nyzul.gearObjective =
{
    AVOID_AGRO     = 1,
    DO_NOT_DESTROY = 2,
}

nyzul.penalty =
{
    TIME   = 1,
    TOKENS = 2,
    PATHOS = 3,
}

nyzul.pathos =
{
    -- Found info: if gaining pathos from failed gear objectives will pick 3 different ways,
    -- 1. token reward reduction, 2. time reduction, 3. random any other effect. Once picked which of
    -- the 3 chioces for the floor, it will always be that for each occurance.

    -- Neg Effects
    [1]  = {effect = dsp.effect.IMPAIRMENT,    power = 0x01,  ID = 7372}, -- Job Abilities
    [2]  = {effect = dsp.effect.IMPAIRMENT,    power = 0x02,  ID = 7374}, -- Weapon Skills
    [3]  = {effect = dsp.effect.OMERTA,        power = 0x01,  ID = 7380}, -- Songs
    [4]  = {effect = dsp.effect.OMERTA,        power = 0x02,  ID = 7378}, -- Black Magic
    [5]  = {effect = dsp.effect.OMERTA,        power = 0x04,  ID = 7386}, -- Blue Magic
    [6]  = {effect = dsp.effect.OMERTA,        power = 0x08,  ID = 7382}, -- Ninjutsu
    [7]  = {effect = dsp.effect.OMERTA,        power = 0x10,  ID = 7384}, -- Summoning Magic
    [8]  = {effect = dsp.effect.OMERTA,        power = 0x20,  ID = 7376}, -- White Magic
    [9]  = {effect = dsp.effect.SLOW,          power = 2000,  ID = 7388}, -- Attack speed reduced, needs retail data
    [10] = {effect = dsp.effect.FAST_CAST,     power = -30,   ID = 7390}, -- Casting speed reduced
    [11] = {effect = dsp.effect.DEBILITATION,  power = 0x001, ID = 7392}, -- STR
    [12] = {effect = dsp.effect.DEBILITATION,  power = 0x002, ID = 7394}, -- DEX
    [13] = {effect = dsp.effect.DEBILITATION,  power = 0x004, ID = 7396}, -- VIT
    [14] = {effect = dsp.effect.DEBILITATION,  power = 0x008, ID = 7398}, -- AGI
    [15] = {effect = dsp.effect.DEBILITATION,  power = 0x010, ID = 7400}, -- INT
    [16] = {effect = dsp.effect.DEBILITATION,  power = 0x020, ID = 7402}, -- MND
    [17] = {effect = dsp.effect.DEBILITATION,  power = 0x040, ID = 7404}, -- CHR
    -- Positive Effects
    [18] = {effect = dsp.effect.REGAIN,        power = 5,     ID = 7406}, -- confirmed 50
    [19] = {effect = dsp.effect.REGEN,         power = 15,    ID = 7408}, -- confirmed 15
    [20] = {effect = dsp.effect.REFRESH,       power = 1,     ID = 7410},
    [21] = {effect = dsp.effect.FLURRY,        power = 15,    ID = 7412},
    [22] = {effect = dsp.effect.CONCENTRATION, power = 30,    ID = 7414},
    [23] = {effect = dsp.effect.STR_BOOST_II,  power = 30,    ID = 7416}, -- confirmed 30
    [24] = {effect = dsp.effect.DEX_BOOST_II,  power = 30,    ID = 7418},
    [25] = {effect = dsp.effect.VIT_BOOST_II,  power = 30,    ID = 7420},
    [26] = {effect = dsp.effect.AGI_BOOST_II,  power = 30,    ID = 7422},
    [27] = {effect = dsp.effect.INT_BOOST_II,  power = 30,    ID = 7424},
    [28] = {effect = dsp.effect.MND_BOOST_II,  power = 30,    ID = 7426},
    [29] = {effect = dsp.effect.CHR_BOOST_II,  power = 30,    ID = 7428},
}

nyzul.FloorLayout =
{
    [0]  = { -20, -0.5, -380}, -- boss floors 20, 40, 60, 80
    --[?] = {-491, -4.0, -500}, -- boss floor 20 confirmed
    [1]  = { 380, -0.5, -500},
    [2]  = { 500, -0.5,  -20},
    [3]  = { 500, -0.5,   60},
    [4]  = { 500, -0.5, -100},
    [5]  = { 540, -0.5, -140},
    [6]  = { 460, -0.5, -219},
    [7]  = { 420, -0.5,  500},
    [8]  = {  60, -0.5, -335},
    [9]  = {  20, -0.5, -500},
    [10] = { -95, -0.5,   60},
    [11] = { 100, -0.5,  100},
    [12] = {-460, -4.0, -180},
    [13] = {-304, -0.5, -380},
    [14] = {-380, -0.5, -500},
    [15] = {-459, -4.0, -540},
    [16] = {-465, -4.0, -340},
    [17] = {504.5, 0.0,  -60},
    --[18] = {580, 0.0, 340},
    --[19] = {455, 0.0, -140},
    --[20] = {500, 0.0, 20},
    --[21] = {500, 0, 380},
    --[22] = {460, 0, 100},
    --[23] = {100, 0, -380},
    --[24] = {-64.5, 0, 60},
}

nyzul.floorCost =
{
    [1]  = {level =  1, cost =    0},
    [2]  = {level =  6, cost =  500},
    [3]  = {level = 11, cost =  550},
    [4]  = {level = 16, cost =  600},
    [5]  = {level = 21, cost =  650},
    [6]  = {level = 26, cost =  700},
    [7]  = {level = 31, cost =  750},
    [8]  = {level = 36, cost =  800},
    [9]  = {level = 41, cost =  850},
    [10] = {level = 46, cost =  900},
    [11] = {level = 51, cost = 1000},
    [12] = {level = 56, cost = 1100},
    [13] = {level = 61, cost = 1200},
    [14] = {level = 66, cost = 1300},
    [15] = {level = 71, cost = 1400},
    [16] = {level = 76, cost = 1500},
    [17] = {level = 81, cost = 1600},
    [18] = {level = 86, cost = 1700},
    [19] = {level = 91, cost = 1800},
    [20] = {level = 96, cost = 1900},
}

nyzul.pickMobs =
{
    [0] = -- 20th Floor bosses
    {
        [40] = -- 20 and 40 floor Bosses
        {
            ADAMANTOISE = 17092999,
            FAFNIR      = 17093001,
        },
        [100] = -- floors 60, 80 and 100 floor bosses
        {
            KHIMAIRA = 17093002,
            CERBERUS = 17093004,
        },
    },
    [1] = -- Enemy Leaders, can appear on all floors but %20 that are on objective
    {
        MOKKE               = 17092944,
        LONG_HORNED_CHARIOT = 17092968,
    },
    [2] = -- Specified Enemies
    {
        [0] = -- Heraldic Imp x5
        {
            17092969, 17092970, 17092971, 17092972, 17092973
        },
        [1] = -- Psycheflayer x5
        {
            17092974, 17092975, 17092976, 17092977, 17092978
        },
        [2] = -- Poroggo Gent x5
        {
            17092979, 17092980, 17092981, 17092982, 17092983
        },
        [3] = -- Ebony Pudding x5
        {
            17092984, 17092985, 17092986, 17092987, 17092988
        },
        [4] = -- Qiqirn_Treasure_Hunter x2
        {
            17092989, 17092990
        },
        [5] = -- Qiqirn_Archaeologist x3
        {
            17092991, 17092992, 17092993
        },
        [6] = -- Racing_Chariot x5
        {
            17092994, 17092995, 17092996, 17092997, 17092998
        },
    },
}

nyzul.FloorEntities = -- regular mobs by layout
{
    [1] = -- Aquans
    {
        17092631, 17092632, 17092633, 17092634, 17092635, 17092636,
        17092637, 17092638, 17092639, 17092640, 17092641, 17092642
    },
    [2] = -- Amorphs
    {
        17092643, 17092644, 17092645, 17092646, 17092647, 17092648,
        17092649, 17092650, 17092651, 17092652, 17092653, 17092654
    },
    [3] = -- Arcana
    {
        17092655, 17092656, 17092657, 17092658, 17092659, 17092660,
        17092661, 17092662, 17092663, 17092664, 17092665, 17092666
    },
    [4] = -- Undead
    {
        17092667, 17092668, 17092669, 17092670, 17092671, 17092672,
        17092673, 17092674, 17092675, 17092676, 17092677, 17092678
    },
    [5] = -- Vermin
    {
        17092679, 17092680, 17092681, 17092682, 17092683, 17092684,
        17092685, 17092686, 17092687, 17092688, 17092689, 17092690
    },
    [6] = -- Demons
    {
        17092691, 17092692, 17092693, 17092694, 17092695, 17092696,
        17092697, 17092698, 17092699, 17092700, 17092701, 17092702
    },
    [7] = -- Dragons
    {
        17092703, 17092704, 17092705, 17092706, 17092707, 17092708,
        17092709, 17092710, 17092711, 17092712, 17092713, 17092714
    },
    [8] = -- Birds
    {
        17092715, 17092716, 17092717, 17092718, 17092719, 17092720,
        17092721, 17092722, 17092723, 17092724, 17092725, 17092726
    },
    [9] = -- Beasts
    {
        17092727, 17092728, 17092729, 17092730, 17092731, 17092732,
        17092733, 17092734, 17092735, 17092736, 17092737, 17092738
    },
    [10] = -- Plantoids
    {
        17092739, 17092740, 17092741, 17092742, 17092743, 17092744,
        17092745, 17092746, 17092747, 17092748, 17092749, 17092750
    },
    [11] =  -- Lizards
    {
        17092751, 17092752, 17092753, 17092754, 17092755, 17092756,
        17092757, 17092758, 17092759, 17092760, 17092761, 17092762
    },
    [12] = -- Amorphs
    {
        17092763, 17092764, 17092765, 17092766, 17092767, 17092768,
        17092769, 17092770, 17092771, 17092772, 17092773, 17092774
    },
    [13] = -- Mixed
    {
        17092775, 17092776, 17092777, 17092778, 17092779, 17092780,
        17092781, 17092782, 17092783, 17092784, 17092785, 17092786
    },
    [14] = -- Mixed
    {
        17092787, 17092788, 17092789, 17092790, 17092791, 17092792,
        17092793, 17092794, 17092795, 17092796, 17092797, 17092798
    },
    [15] = -- Amorphs
    {
        17092799, 17092800, 17092801, 17092802, 17092803, 17092804,
        17092805, 17092806, 17092807, 17092808, 17092809, 17092810
    },
    [16] = -- Arcana
    {
        17092811, 17092812, 17092813, 17092814, 17092815, 17092816,
        17092817, 17092818, 17092819, 17092820, 17092821, 17092822
    },
    [17] = -- Gears
    {
        start = 17092916,
        stop  = 17092921,
    },
}

nyzul.appraisalItems =
{
        [appraisalUtil.Origin.NYZUL_BAT_EYE] =               dsp.items.APPRAISAL_AXE,
        [appraisalUtil.Origin.NYZUL_SHADOW_EYE] =            dsp.items.APPRAISAL_NECKLACE,
        [appraisalUtil.Origin.NYZUL_BOMB_KING] =             dsp.items.APPRAISAL_RING,
        [appraisalUtil.Origin.NYZUL_JUGGLER_HECATOMB] =      dsp.items.APPRAISAL_POLEARM,
        [appraisalUtil.Origin.NYZUL_SMOTHERING_SCHMIDT] =    dsp.items.APPRAISAL_RING,
        [appraisalUtil.Origin.NYZUL_HELLION] =               dsp.items.APPRAISAL_POLEARM,
        [appraisalUtil.Origin.NYZUL_LEAPING_LIZZY] =         dsp.items.APPRAISAL_FOOTWEAR,
        [appraisalUtil.Origin.NYZUL_TOM_TIT_TAT] =           dsp.items.APPRAISAL_DAGGER,
        [appraisalUtil.Origin.NYZUL_JAGGEDY_EARED_JACK] =    dsp.items.APPRAISAL_NECKLACE,
        [appraisalUtil.Origin.NYZUL_CACTUAR_CANTAUTOR] =     dsp.items.APPRAISAL_FOOTWEAR,
        [appraisalUtil.Origin.NYZUL_GARGANTUA] =             dsp.items.APPRAISAL_NECKLACE,
        [appraisalUtil.Origin.NYZUL_GYRE_CARLIN] =           dsp.items.APPRAISAL_BOW,
        [appraisalUtil.Origin.NYZUL_ASPHYXIATED_AMSEL] =     dsp.items.APPRAISAL_RING,
        [appraisalUtil.Origin.NYZUL_FROSTMANE] =             dsp.items.APPRAISAL_SWORD,
        [appraisalUtil.Origin.NYZUL_PEALLAIDH] =             dsp.items.APPRAISAL_GLOVES,
        [appraisalUtil.Origin.NYZUL_CARNERO] =               dsp.items.APPRAISAL_SWORD,
        [appraisalUtil.Origin.NYZUL_FALCATUS_ARANEI] =       dsp.items.APPRAISAL_POLEARM,
        [appraisalUtil.Origin.NYZUL_EMERGENT_ELM] =          dsp.items.APPRAISAL_SWORD,
        [appraisalUtil.Origin.NYZUL_OLD_TWO_WINGS] =         dsp.items.APPRAISAL_CAPE,
        [appraisalUtil.Origin.NYZUL_AIATAR] =                dsp.items.APPRAISAL_BOX,
        [appraisalUtil.Origin.NYZUL_INTULO] =                dsp.items.APPRAISAL_BOX,
        [appraisalUtil.Origin.NYZUL_ORCTRAP] =               dsp.items.APPRAISAL_DAGGER,
        [appraisalUtil.Origin.NYZUL_VALKURM_EMPEROR] =       dsp.items.APPRAISAL_HEADPIECE,
        [appraisalUtil.Origin.NYZUL_CRUSHED_KRAUSE] =        dsp.items.APPRAISAL_RING,
        [appraisalUtil.Origin.NYZUL_STINGING_SOPHIE] =       dsp.items.APPRAISAL_DAGGER,
        [appraisalUtil.Origin.NYZUL_SERPOPARD_ISHTAR] =      dsp.items.APPRAISAL_NECKLACE,
        [appraisalUtil.Origin.NYZUL_WESTERN_SHADOW] =        dsp.items.APPRAISAL_DAGGER,
        [appraisalUtil.Origin.NYZUL_BLOODTEAR_BALDURF] =     dsp.items.APPRAISAL_SHIELD,
        [appraisalUtil.Origin.NYZUL_ZIZZY_ZILLAH] =          dsp.items.APPRAISAL_SWORD,
        [appraisalUtil.Origin.NYZUL_ELLYLLON] =              dsp.items.APPRAISAL_HEADPIECE,
        [appraisalUtil.Origin.NYZUL_MISCHIEVOUS_MICHOLAS] =  dsp.items.APPRAISAL_DAGGER,
        [appraisalUtil.Origin.NYZUL_LEECH_KING] =            dsp.items.APPRAISAL_EARRING,
        [appraisalUtil.Origin.NYZUL_EASTERN_SHADOW] =        dsp.items.APPRAISAL_BOW,
        [appraisalUtil.Origin.NYZUL_NUNYENUNC] =             dsp.items.APPRAISAL_POLEARM,
        [appraisalUtil.Origin.NYZUL_HELLDIVER] =             dsp.items.APPRAISAL_BOW,
        [appraisalUtil.Origin.NYZUL_TAISAIJIN] =             dsp.items.APPRAISAL_HEADPIECE,
        [appraisalUtil.Origin.NYZUL_FUNGUS_BEETLE] =         dsp.items.APPRAISAL_SHIELD,
        [appraisalUtil.Origin.NYZUL_FRIAR_RUSH] =            dsp.items.APPRAISAL_BOX,
        [appraisalUtil.Origin.NYZUL_PULVERIZED_PFEFFER] =    dsp.items.APPRAISAL_RING,
        [appraisalUtil.Origin.NYZUL_ARGUS] =                 dsp.items.APPRAISAL_NECKLACE,
        [appraisalUtil.Origin.NYZUL_BLOODPOOL_VORAX] =       dsp.items.APPRAISAL_NECKLACE,
        [appraisalUtil.Origin.NYZUL_NIGHTMARE_VASE] =        dsp.items.APPRAISAL_DAGGER,
        [appraisalUtil.Origin.NYZUL_DAGGERCLAW_DRACOS] =     dsp.items.APPRAISAL_DAGGER,
        [appraisalUtil.Origin.NYZUL_NORTHERN_SHADOW] =       dsp.items.APPRAISAL_AXE,
        [appraisalUtil.Origin.NYZUL_FRAELISSA] =            {dsp.items.APPRAISAL_CAPE, dsp.items.APPRAISAL_BOW},
        [appraisalUtil.Origin.NYZUL_ROC] =                   dsp.items.APPRAISAL_POLEARM,
        [appraisalUtil.Origin.NYZUL_SABOTENDER_BAILARIN] =   dsp.items.APPRAISAL_BOX,
        [appraisalUtil.Origin.NYZUL_AQUARIUS] =              dsp.items.APPRAISAL_AXE,
        [appraisalUtil.Origin.NYZUL_ENERGETIC_ERUCA] =       dsp.items.APPRAISAL_GLOVES,
        [appraisalUtil.Origin.NYZUL_SPINY_SPIPI] =           dsp.items.APPRAISAL_CAPE,
        [appraisalUtil.Origin.NYZUL_TRICKSTER_KINETIX] =     dsp.items.APPRAISAL_AXE,
        [appraisalUtil.Origin.NYZUL_DROOLING_DAISY] =        dsp.items.APPRAISAL_HEADPIECE,
        [appraisalUtil.Origin.NYZUL_BONNACON] =              dsp.items.APPRAISAL_FOOTWEAR,
        [appraisalUtil.Origin.NYZUL_GOLDEN_BAT] =            dsp.items.APPRAISAL_CAPE,
        [appraisalUtil.Origin.NYZUL_STEELFLEECE_BALDARICH] = dsp.items.APPRAISAL_SHIELD,
        [appraisalUtil.Origin.NYZUL_SABOTENDER_MARIACHI] =   dsp.items.APPRAISAL_DAGGER,
        [appraisalUtil.Origin.NYZUL_UNGUR] =                 dsp.items.APPRAISAL_BOW,
        [appraisalUtil.Origin.NYZUL_SWAMFISK] =              dsp.items.APPRAISAL_POLEARM,
        [appraisalUtil.Origin.NYZUL_BUBURIMBOO] =            dsp.items.APPRAISAL_NECKLACE,
        [appraisalUtil.Origin.NYZUL_KEEPER_OF_HALIDOM] =     dsp.items.APPRAISAL_SWORD,
        [appraisalUtil.Origin.NYZUL_SERKET] =                dsp.items.APPRAISAL_RING,
        [appraisalUtil.Origin.NYZUL_DUNE_WIDOW] =            dsp.items.APPRAISAL_NECKLACE,
        [appraisalUtil.Origin.NYZUL_ODQAN] =                 dsp.items.APPRAISAL_BOX,
        [appraisalUtil.Origin.NYZUL_BURNED_BERGMANN] =       dsp.items.APPRAISAL_RING,
        [appraisalUtil.Origin.NYZUL_TYRANNIC_TUNNOK] =       dsp.items.APPRAISAL_AXE,
        [appraisalUtil.Origin.NYZUL_BLOODSUCKER] =           dsp.items.APPRAISAL_RING,
        [appraisalUtil.Origin.NYZUL_TOTTERING_TOBY] =        dsp.items.APPRAISAL_FOOTWEAR,
        [appraisalUtil.Origin.NYZUL_SOUTHERN_SHADOW] =       dsp.items.APPRAISAL_SHIELD,
        [appraisalUtil.Origin.NYZUL_SHARP_EARED_ROPIPI] =    dsp.items.APPRAISAL_HEADPIECE,
        [appraisalUtil.Origin.NYZUL_PANZER_PERCIVAL] =       dsp.items.APPRAISAL_AXE,
        [appraisalUtil.Origin.NYZUL_VOUIVRE] =               dsp.items.APPRAISAL_POLEARM,
        [appraisalUtil.Origin.NYZUL_JOLLY_GREEN] =           dsp.items.APPRAISAL_SASH,
        [appraisalUtil.Origin.NYZUL_TUMBLING_TRUFFLE] =      dsp.items.APPRAISAL_HEADPIECE,
        [appraisalUtil.Origin.NYZUL_CAPRICIOUS_CASSIE] =     dsp.items.APPRAISAL_EARRING,
        [appraisalUtil.Origin.NYZUL_AMIKIRI] =               dsp.items.APPRAISAL_SWORD,
        [appraisalUtil.Origin.NYZUL_STRAY_MARY] =            dsp.items.APPRAISAL_BOX,
        [appraisalUtil.Origin.NYZUL_SEWER_SYRUP] =           dsp.items.APPRAISAL_RING,
        [appraisalUtil.Origin.NYZUL_UNUT] =                  dsp.items.APPRAISAL_BOX,
        [appraisalUtil.Origin.NYZUL_SIMURGH] =               dsp.items.APPRAISAL_FOOTWEAR,
        [appraisalUtil.Origin.NYZUL_PELICAN] =               dsp.items.APPRAISAL_SHIELD,
        [appraisalUtil.Origin.NYZUL_CARGO_CRAB_COLIN] =      dsp.items.APPRAISAL_SWORD,
        [appraisalUtil.Origin.NYZUL_WOUNDED_WURFEL] =        dsp.items.APPRAISAL_RING,
        [appraisalUtil.Origin.NYZUL_PEG_POWLER] =            dsp.items.APPRAISAL_AXE,
        [appraisalUtil.Origin.NYZUL_JADED_JODY] =            dsp.items.APPRAISAL_BOX,
        [appraisalUtil.Origin.NYZUL_MAIGHDEAN_UAINE] =       dsp.items.APPRAISAL_EARRING,
}

function nyzul.handleAppraisalItem(player, npc)
    local instance = npc:getInstance()
    local chars = instance:getChars()

    for _, cofferID in ipairs(ID.npc.TREASURE_COFFER) do
        if npc:getID() == cofferID and npc:getLocalVar("opened") == 0 then
            -- Appraisal Items
            local mobOffset = npc:getLocalVar("appraisalItem") - 17092723

            if mobOffset == 166 or mobOffset == 187 then
                mobOffset = 108
            elseif mobOffset == 154 or mobOffset == 172 or mobOffset == 190 then
                mobOffset = 136
            end

            local itemID = nyzul.appraisalItems[mobOffset]

            if type(itemID) == "table" then
                local pick = math.random(1, #itemID)
                itemID = itemID[pick]
            end

            if player:getFreeSlotsCount() == 0 then
                player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, itemID)
                return
            end

            player:addItem({id = itemID, appraisal = mobOffset})

            for _, players in pairs(chars) do
                players:messageName(ID.text.PLAYER_OBTAINS_ITEM, player, itemID)
            end

            npc:entityAnimationPacket("open")
            npc:setLocalVar("opened", 1)
            npc:untargetable(true)
            npc:queue(10000, function(npc) npc:entityAnimationPacket("kesu") end)
            npc:queue(12000, function(npc) npc:setStatus(dsp.status.DISAPPEAR) npc:resetLocalVars() npc:AnimationSub(0) end)
            break
        end
    end
end

function nyzul.tempBoxTrigger(player, npc)
    if npc:getLocalVar("itemsPicked") == 0 then
        npc:setLocalVar("itemsPicked", 1)
        npc:entityAnimationPacket("open")
        npc:AnimationSub(13)
        nyzul.tempBoxPickItems(npc)
    end

    player:startEvent(2, {[0] = (npc:getLocalVar("itemID_1") + (npc:getLocalVar("itemAmount_1") * 65536)),
    [1] = (npc:getLocalVar("itemID_2") + (npc:getLocalVar("itemAmount_2") * 65536)),
    [2] = (npc:getLocalVar("itemID_3") + (npc:getLocalVar("itemAmount_3") * 65536))})
end

function nyzul.tempBoxPickItems(npc)
    local tempBoxItems =
    {
        [1] = {itemID = dsp.items.BOTTLE_OF_BARBARIANS_DRINK, amount = math.random(1,3)},
        [2] = {itemID = dsp.items.BOTTLE_OF_FIGHTERS_DRINK,   amount = math.random(1,3)},
        [3] = {itemID = dsp.items.BOTTLE_OF_ORACLES_DRINK,    amount = math.random(1,3)},
        [4] = {itemID = dsp.items.BOTTLE_OF_ASSASSINS_DRINK,  amount = math.random(1,3)},
        [5] = {itemID = dsp.items.BOTTLE_OF_SPYS_DRINK,       amount = math.random(1,3)},
        [6] = {itemID = dsp.items.BOTTLE_OF_BRAVERS_DRINK,    amount = math.random(1,3)},
        [7] = {itemID = dsp.items.BOTTLE_OF_SOLDIERS_DRINK,   amount = math.random(1,3)},
        [8] = {itemID = dsp.items.BOTTLE_OF_CHAMPIONS_DRINK,  amount = math.random(1,3)},
        [9] = {itemID = dsp.items.BOTTLE_OF_MONARCHS_DRINK,   amount = math.random(1,3)},
        [10] = {itemID = dsp.items.BOTTLE_OF_GNOSTICS_DRINK,  amount = math.random(1,3)},
        [11] = {itemID = dsp.items.BOTTLE_OF_CLERICS_DRINK,   amount = math.random(1,3)},
        [12] = {itemID = dsp.items.BOTTLE_OF_SHEPHERDS_DRINK, amount = math.random(1,3)},
        [13] = {itemID = dsp.items.BOTTLE_OF_SPRINTERS_DRINK, amount = math.random(1,3)},
        [14] = {itemID = dsp.items.FLASK_OF_STRANGE_MILK,     amount = math.random(1,5)},
        [15] = {itemID = dsp.items.BOTTLE_OF_STRANGE_JUICE,    amount = math.random(1,5)},
        [16] = {itemID = dsp.items.BOTTLE_OF_FANATICS_DRINK,  amount = 1},
        [17] = {itemID = dsp.items.BOTTLE_OF_FOOLS_DRINK,     amount = 1},
        [18] = {itemID = dsp.items.DUSTY_WING,                amount = 1},
        [19] = {itemID = dsp.items.BOTTLE_OF_VICARS_DRINK,    amount = math.random(1,3)},
        [20] = {itemID = dsp.items.DUSTY_POTION,              amount = math.random(1,3)},
        [21] = {itemID = dsp.items.DUSTY_ETHER,               amount= math.random(1,3)},
        [22] = {itemID = dsp.items.DUSTY_ELIXIR,              amount = 1}
    }
    local random = math.random(1,#tempBoxItems)
    local item = tempBoxItems[random]
    local item2_random = math.random(1,10) > 4
    local item3_random = math.random(1,10) > 8

    if npc:getLocalVar("itemID_1") == 0 then
        npc:setLocalVar("itemID_1", item.itemID)
        npc:setLocalVar("itemAmount_1", item.amount)
        table.remove(tempBoxItems, random)
    end

    if item2_random then
        random = math.random(1,#tempBoxItems)
        local item = tempBoxItems[random]

        npc:setLocalVar("itemID_2", item.itemID)
        npc:setLocalVar("itemAmount_2", item.amount)
        table.remove(tempBoxItems, random)
    end
    if item2_random and item3_random then
        random = math.random(1,#tempBoxItems)
        local item = tempBoxItems[random]

        npc:setLocalVar("itemID_3", item.itemID)
        npc:setLocalVar("itemAmount_3", item.amount)
        table.remove(tempBoxItems, random)
    end
end

function nyzul.tempBoxFinish(player, csid, option, npc)
    local ID = require("scripts/zones/"..player:getZoneName().."/IDs")

    if csid == 2 then
        local item_1 = npc:getLocalVar("itemID_1")
        local item_2 = npc:getLocalVar("itemID_2")
        local item_3 = npc:getLocalVar("itemID_3")
        if option == 1 and item_1 > 0 and npc:getLocalVar("itemAmount_1") > 0 then
            if not player:hasItem(item_1, dsp.inventoryLocation.TEMPITEMS) then
                player:addTempItem(item_1)
                player:messageName(ID.text.PLAYER_OBTAINS_TEMP_ITEM, player, item_1)
                npc:setLocalVar("itemAmount_1", npc:getLocalVar("itemAmount_1") - 1)
            else
                player:messageSpecial(ID.text.ALREADY_HAVE_TEMP_ITEM)
            end
        elseif option == 2 and item_2 > 0 and npc:getLocalVar("itemAmount_2") > 0 then
            if not player:hasItem(item_2, dsp.inventoryLocation.TEMPITEMS) then
                player:addTempItem(item_2)
                player:messageName(ID.text.PLAYER_OBTAINS_TEMP_ITEM, player, item_2)
                npc:setLocalVar("itemAmount_2", npc:getLocalVar("itemAmount_2") - 1)
            else
                player:messageSpecial(ID.text.ALREADY_HAVE_TEMP_ITEM)
            end
        elseif option == 3 and item_3 > 0 and npc:getLocalVar("itemAmount_3") > 0 then
            if not player:hasItem(item_3, dsp.inventoryLocation.TEMPITEMS) then
                player:addTempItem(item_3)
                player:messageName(ID.text.PLAYER_OBTAINS_TEMP_ITEM, player, item_3)
                npc:setLocalVar("itemAmount_3", npc:getLocalVar("itemAmount_3") - 1)
            else
                player:messageSpecial(ID.text.ALREADY_HAVE_TEMP_ITEM)
            end
        end
        if npc:getLocalVar("itemAmount_1") == 0 and npc:getLocalVar("itemAmount_2") == 0 and npc:getLocalVar("itemAmount_3") == 0 then
            npc:queue(10000, function(npc) npc:entityAnimationPacket("kesu") end)
            npc:queue(12000, function(npc) npc:setStatus(dsp.status.DISAPPEAR) npc:AnimationSub(0) npc:resetLocalVars() end)
        end
    end
end

function nyzul.clearChests(instance)
    for _, cofferID in ipairs(ID.npc.TREASURE_COFFER) do
        npc = GetNPCByID(cofferID, instance)
        if npc:getStatus() ~= dsp.status.DISAPPEAR then
            npc:setStatus(dsp.status.DISAPPEAR)
            npc:AnimationSub(0)
            npc:resetLocalVars()
        end
    end

    if ENABLE_NYZUL_CASKETS == 1 then
        for _, casketID in ipairs(ID.npc.TREASURE_CASKET) do
            npc = GetNPCByID(casketID, instance)
            if npc:getStatus() ~= dsp.status.DISAPPEAR then
                npc:setStatus(dsp.status.DISAPPEAR)
                npc:AnimationSub(0)
                npc:resetLocalVars()
            end
        end
    end
end

function nyzul.handleRunicKey(mob)
    local instance = mob:getInstance()

    if instance:getLocalVar("Nyzul_Current_Floor") == 100 then
        local chars = instance:getChars()
        local startFloor = instance:getLocalVar("Nyzul_Isle_StartingFloor")

        for _, entity in pairs(chars) do
            -- Does players Runic Disk have data saved to a floor of entering or higher
            if entity:getVar("NyzulFloorProgress") + 1 >= startFloor and not entity:hasKeyItem(dsp.ki.RUNIC_KEY) then
                if RUNIC_DISK_SAVE == 0 then -- On early version only initiator of floor got progress saves and key credit
                    if entity:getID() == instance:getLocalVar("diskHolder") then
                        if npcUtil.giveKeyItem(entity, dsp.ki.RUNIC_KEY) then
                            entity:setVar("NyzulFloorProgress", 0)
                        end
                    end
                else -- Anyone can get a key on 100 win if disk passed check
                    npcUtil.giveKeyItem(entity, dsp.ki.RUNIC_KEY)
                end
            end
        end
    end
end

function nyzul.handleProgress(instance, progress)
    local chars = instance:getChars()
    local stage = instance:getStage()
    local currectFloor = instance:getLocalVar("Nyzul_Current_Floor")
    local complete = false

    if ((stage == nyzul.objective.FREE_FLOOR or
            stage == nyzul.objective.ELIMINATE_ENEMY_LEADER or
            stage == nyzul.objective.ACTIVATE_ALL_LAMPS or
            stage == nyzul.objective.ELIMINATE_SPECIFIED_ENEMY) and
            progress == 15)
        or
        ((stage == nyzul.objective.ELIMINATE_ALL_ENEMIES or
            stage == nyzul.objective.ELIMINATE_SPECIFIED_ENEMIES) and
            progress >= instance:getLocalVar("Eliminate"))
    then
        instance:setProgress(0)
        instance:setLocalVar("Eliminate", 0)
        instance:setLocalVar("potential_tokens", calculate_tokens(instance))
        for _, players in ipairs(chars) do
            players:messageSpecial(ID.text.OBJECTIVE_COMPLETE, currectFloor)
        end
        complete = true
    end
    return complete
end

function nyzul.enemyLeaderKill(mob)
    local instance = mob:getInstance()
    instance:setProgress(15)
end

function nyzul.specifiedGroupKill(mob)
    local instance = mob:getInstance()
    if instance:getStage() == nyzul.objective.ELIMINATE_SPECIFIED_ENEMIES then
        instance:setProgress(instance:getProgress() + 1)
    end
end

function nyzul.specifiedEnemySet(mob)
    local instance = mob:getInstance()
    if instance:getStage() == nyzul.objective.ELIMINATE_SPECIFIED_ENEMY then
        if instance:getLocalVar("Nyzul_Specified_Enemy") == mob:getID() then
            mob:setMobMod(dsp.mobMod.CHECK_AS_NM, 1)
        end
    end
end

function nyzul.specifiedEnemyKill(mob)
    local instance = mob:getInstance()
    if instance:getStage() == nyzul.objective.ELIMINATE_SPECIFIED_ENEMY then
        if instance:getLocalVar("Nyzul_Specified_Enemy") == mob:getID() then
            instance:setProgress(15)
            instance:setLocalVar("Nyzul_Specified_Enemy", 0)
        end
    elseif instance:getStage() == nyzul.objective.ELIMINATE_ALL_ENEMIES then
        instance:setProgress(instance:getProgress() + 1)
    end
end

function nyzul.eliminateAllKill(mob)
    local instance = mob:getInstance()
    if instance:getStage() == nyzul.objective.ELIMINATE_ALL_ENEMIES then
        instance:setProgress(instance:getProgress() + 1)
    end
end

function nyzul.activateRuneOfTransfer(instance)
    for _, runeID in pairs(ID.npc.RUNE_OF_TRANSFER) do
        if GetNPCByID(runeID, instance):getStatus() == dsp.status.NORMAL then
            GetNPCByID(runeID, instance):AnimationSub(1)
            break
        end
    end
end

function nyzul.vigilWeaponDrop(player, mob)
    local instance = mob:getInstance()

    -- Only floor 100 Bosses to drop 1 random weapon guarenteed and 1 of the disk holders job
    -- will not drop diskholder's weapon if anyone already has it.
    if instance:getLocalVar("Nyzul_Current_Floor") == 100 then
        local diskHolder = GetPlayerByID(instance:getLocalVar("diskHolder"), instance)
        local chars = instance:getChars()
        if diskHolder ~= nil then
            for _, entity in pairs(chars) do
                if not entity:hasItem(nyzul.baseWeapons[diskHolder:getMainJob()]) then
                    player:addTreasure(nyzul.baseWeapons[diskHolder:getMainJob()], mob)
                    break
                end
            end
        end
        player:addTreasure(nyzul.baseWeapons[math.random(1, #nyzul.baseWeapons)], mob)
    -- Every NM can randomly drop a vigil weapon
    elseif math.random(100) <= 20 and ENABLE_VIGIL_DROPS == 1 then
        player:addTreasure(nyzul.baseWeapons[math.random(1, #nyzul.baseWeapons)], mob)
    end
end

function nyzul.spawnChest(mob, player)
    local instance = mob:getInstance()
    local mobID = mob:getID()

    if mobID >= ID.mob[NYZUL_ISLE_INVESTIGATION].BAT_EYE and mobID <= ID.mob[NYZUL_ISLE_INVESTIGATION].TAISAIJIN then
        
        nyzul.vigilWeaponDrop(player, mob)

        for _, cofferID in ipairs(ID.npc.TREASURE_COFFER) do
            local coffer = GetNPCByID(cofferID, instance)
            if coffer:getStatus() == dsp.status.DISAPPEAR then
                local pos = mob:getPos()
                coffer:untargetable(false)
                coffer:setPos(pos.x, pos.y, pos.z, pos.rot)
                coffer:setLocalVar("appraisalItem", mobID)
                coffer:setStatus(dsp.status.NORMAL)
                break
            end
        end
    elseif mobID < ID.mob[NYZUL_ISLE_INVESTIGATION].ADAMANTOISE and ENABLE_NYZUL_CASKETS == 1 then
        if math.random(100) <= 6 then
            for _, casketID in ipairs(ID.npc.TREASURE_CASKET) do
                local casket = GetNPCByID(casketID, instance)
                if casket:getStatus() == dsp.status.DISAPPEAR then
                    local pos = mob:getPos()
                    casket:setPos(pos.x, pos.y, pos.z, pos.rot)
                    casket:setStatus(dsp.status.NORMAL)
                    break
                end
            end
        end
    end
end

function nyzul.removePathos(instance)
    if instance:getLocalVar("floorPathos") > 0 then
        for i = 1, 29 do
            if utils.isBitSet(instance:getLocalVar("floorPathos"), i) then
                local removeMessage = nyzul.pathos[i].ID
                local chars = instance:getChars()

                for _, players in pairs(chars) do
                    players:delStatusEffectSilent(nyzul.pathos[i].effect)
                    players:messageSpecial(removeMessage - 1)
                    if players:hasPet() then
                        local pet = players:getPet()
                        pet:delStatusEffectSilent(nyzul.pathos[i].effect)
                    end
                end
                instance:setLocalVar("floorPathos",utils.setBit(instance:getLocalVar("floorPathos"), i, 0))
            end
        end
    end
end

function nyzul.addFloorPathos(instance)
    local randomPathos = instance:getLocalVar("randomPathos")

    if randomPathos > 0 then
        instance:setLocalVar("floorPathos", utils.setBit(instance:getLocalVar("floorPathos"), randomPathos, 1))

        local pathos = nyzul.pathos[randomPathos]
        local chars = instance:getChars()

        for _, players in pairs(chars) do
            players:addStatusEffect(pathos.effect, pathos.power, 0, 0)
            players:getStatusEffect(pathos.effect):unsetFlag(3) -- dispelable + eraseable
            players:getStatusEffect(pathos.effect):setFlag(8388864) -- on zone + no cancel
            players:messageSpecial(pathos.ID)
            if players:hasPet() then
                local pet = players:getPet()
                pet:addStatusEffectEx(pathos.effect, pathos.effect, pathos.power, 0, 0)
                pet:getStatusEffect(pathos.effect):unsetFlag(3) -- dispelable + eraseable
                pet:getStatusEffect(pathos.effect):setFlag(8388864) -- on zone + no cancel
            end
        end
        instance:setLocalVar("randomPathos", 0)
    end
end

function nyzul.addPenalty(mob)
    local instance = mob:getInstance()
    local pathos = instance:getLocalVar("floorPathos")
    local penalty = instance:getLocalVar("gearPenalty")
    local chars = instance:getChars()

    if penalty == nyzul.penalty.TIME then
        local timeLimit = instance:getTimeLimit() * 60

        instance:setTimeLimit(timeLimit - 60)
        for _, players in pairs(chars) do
            players:messageSpecial(ID.text.MALFUNCTION)
            players:messageSpecial(ID.text.TIME_LOSS, 1)
        end
    elseif penalty == nyzul.penalty.TOKENS then
        local tokenPenalty = instance:getLocalVar("tokenPenalty")

        tokenPenalty = tokenPenalty + 1
        instance:setLocalVar("tokenPenalty", tokenPenalty)
        for _, players in pairs(chars) do
            players:messageSpecial(ID.text.MALFUNCTION)
            players:messageSpecial(ID.text.TOKEN_LOSS)
        end
    else
        for i = 1, 17 do
            local randomEffect = math.random(1, 17)
            if not utils.isBitSet(pathos, randomEffect) then

                instance:setLocalVar("floorPathos", utils.setBit(pathos, randomEffect, 1))
                local pathos = nyzul.pathos[randomEffect]
                local effect = pathos.effect
                local power = pathos.power
                for _, players in pairs(chars) do
                    if effect == dsp.effect.IMPAIRMENT or effect == dsp.effect.OMERTA or effect == dsp.effect.DEBILITATION then
                        if players:hasStatusEffect(effect) then
                            local statusEffect = players:getStatusEffect(effect)
                            local effectPower = statusEffect:getPower()
                            power = bit.bor(effectPower, power)
                        end
                    end
                    players:addStatusEffect(effect, power, 0, 0)
                    players:getStatusEffect(effect):unsetFlag(3) -- dispelable + eraseable
                    players:getStatusEffect(effect):setFlag(8388864) -- on zone + no cancel
                    players:messageSpecial(ID.text.MALFUNCTION)
                    players:messageSpecial(pathos.ID)
                    if players:hasPet() then
                        local pet = players:getPet()
                        pet:addStatusEffectEx(effect, effect, power, 0, 0)
                        pet:getStatusEffect(effect):unsetFlag(3) -- dispelable + eraseable
                        pet:getStatusEffect(effect):setFlag(8388864) -- on zone + no cancel
                    end
                end
                break
            end
        end
    end
end

function nyzul.get_token_penalty(instance)
    local floor_penalities = instance:getLocalVar("tokenPenalty")
    local rate = get_token_rate(instance)

    return math.floor(117 * rate) * floor_penalities
end

function get_token_rate(instance)
    local party_size = instance:getLocalVar("partySize")
    local rate = 1

    if party_size > 3 then
        rate = rate - ((party_size - 3 ) * .1)
    end

    return rate
end

function get_relative_floor(instance)
    local current_floor = instance:getLocalVar("Nyzul_Current_Floor")
    local starting_floor = instance:getLocalVar("Nyzul_Isle_StartingFloor")

    if current_floor < starting_floor then
        return current_floor + 100
    end

    return current_floor
end

function get_traveled_floors(instance)
    local traveled_floors = 0
    local relative_floor = get_relative_floor(instance)
    local starting_floor = instance:getLocalVar("Nyzul_Isle_StartingFloor")

    traveled_floors = (relative_floor - starting_floor)

    return traveled_floors
end

function calculate_tokens(instance)
    local relative_floor = get_relative_floor(instance)
    local rate = get_token_rate(instance)
    local potential_tokens = instance:getLocalVar("potential_tokens")
    local floor_bonus = 0
    local traveled_floors = get_traveled_floors(instance)

    if relative_floor > 1 then
        floor_bonus = (10 * math.floor((relative_floor - 1) / 5))
    end

    potential_tokens = math.floor(potential_tokens + (200 + floor_bonus) * rate)

    return potential_tokens
end
