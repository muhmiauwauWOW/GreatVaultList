local addonName = ...
local L, _ = GreatVaultList:GetLibs()

local TabID = "dungeonLoot"
local Tab = GreatVaultList:NewModule(TabID, GREATVAULTLIST_TABS)

Tab.id = TabID
Tab.name = string.format(L["tabLoot_name"], DUNGEONS)
Tab.template = "GreatVaultListDungeonLootTemplate"

GreatVaultListDungeonLootListMixin = CreateFromMixins(
                                         GreatVaultListLootListMixin);

GreatVaultListDungeonLootListMixin.id = TabID
GreatVaultListDungeonLootListMixin.tabName = Tab.name
GreatVaultListDungeonLootListMixin.sortOrder = 4

function GreatVaultListDungeonLootListMixin:OnLoad()
    GreatVaultListLootListMixin.OnLoad(self)
    -- GreatVaultList.ElvUi:AddTab(self)
end

function GreatVaultListDungeonLootListMixin:GetHelpConfig()

    local width = self:GetWidth()
    local height = self:GetHeight() + 50

    local helpConfig = {
        FramePos = {x = 0, y = 0},
        FrameSize = {width = width, height = height},
        [1] = {
            ButtonPos = {position = "CENTER"},
            HighLightBox = {
                x = 5,
                y = -40,
                width = width + 10,
                height = height - 40 - 5 - 50
            },
            ToolTipDir = "RIGHT",
            ToolTipText = L["HELP_Loot_table"]
        }
    }

    return helpConfig
end

function GreatVaultListDungeonLootListMixin:BuildData()

    self:AddColumn(L["dungeonLoot_col1"])
    self:AddColumn(L["tabLoot_ilvl"], true, L["dungeonLoot_col2"])
    self:AddColumn(L["tabLoot_upgradelvl"], true, L["dungeonLoot_col2"])
    self:AddColumn(L["tabLoot_ilvl"], true, L["tabLoot_greatVault"])
    self:AddColumn(L["tabLoot_upgradelvl"], false, L["tabLoot_greatVault"])
    self:AddColumn(L["tabLoot_crests"], false, L["tabLoot_crests_desc"])


	local crestIcons = {
		["weathered"] = "|T"..C_CurrencyInfo.GetCurrencyInfo(3285).iconFileID..":12|t",
		["carved"] = "|T"..C_CurrencyInfo.GetCurrencyInfo(3287).iconFileID..":12|t",
		["runed"] = "|T"..C_CurrencyInfo.GetCurrencyInfo(3289).iconFileID..":12|t",
		["gilded"] = "|T"..C_CurrencyInfo.GetCurrencyInfo(3290).iconFileID..":12|t"
	}


	local function buildEntry(lvl, ilvl1, ilvl2, crest, crestamount)

		local crests
		if crestamount then
			crests = string.format("%sx%d", crestIcons[crest], crestamount)
		else
			crests = crestIcons[crest]
		end

		local entry = {
			PLAYER_DIFFICULTY2,
			ilvl1,
			GreatVaultList.itemlvl:GetHighestTrackString(ilvl1),
			ilvl2,
			GreatVaultList.itemlvl:GetHighestTrackString(ilvl2),
			crests
		};

		return entry
	end
	

    self.ItemList.data = {
		buildEntry(PLAYER_DIFFICULTY2, 665, 678, "weathered"),
		{ 
			PLAYER_DIFFICULTY2,
			665,
			GreatVaultList.itemlvl:GetHighestTrackString(665),
			678,
			GreatVaultList.itemlvl:GetHighestTrackString(678),
			crestIcons["weathered"]

		},
		{ 
			PLAYER_DIFFICULTY6,
			681,
			L["gearTrack_Champion"] .. " 1/8",
			691,
			L["gearTrack_Champion"] .. "  4/8",
			crestIcons["carved"]
		},
        {
            2,
            684,
            L["gearTrack_Champion"] .. " 2/8",
            694,
            L["gearTrack_Hero"] .. " 1/6",
            crestIcons["runed"] .. " x10"
        },
        {
            3,
            684,
            L["gearTrack_Champion"] .. " 2/8",
            694,
            L["gearTrack_Hero"] .. " 1/6",
            crestIcons["runed"] .. " x12"
        },
        {
            4,
            688,
            L["gearTrack_Champion"] .. " 3/8",
            697,
            L["gearTrack_Hero"] .. " 2/6",
            crestIcons["runed"] .. " x14"
        },
        {
            5,
            691,
            L["gearTrack_Champion"] .. " 4/8",
            697,
            L["gearTrack_Hero"] .. " 2/6",
            crestIcons["runed"] .. " x16"
        },
        {
            6,
            694,
            L["gearTrack_Hero"] .. " 1/6",
            701,
            L["gearTrack_Hero"] .. " 3/6",
            crestIcons["runed"] .. " x18"
        },
        {
            7,
            694,
            L["gearTrack_Hero"] .. " 1/6",
            704,
            L["gearTrack_Hero"] .. " 4/6",
            crestIcons["gilded"] .. " x10"
        },
        {
            8,
            697,
            L["gearTrack_Hero"] .. " 2/6",
            704,
            L["gearTrack_Hero"] .. " 4/6",
            crestIcons["gilded"] .. " x12"
        },
        {
            9,
            697,
            L["gearTrack_Hero"] .. " 2/6",
            704,
            L["gearTrack_Hero"] .. " 4/6",
            crestIcons["gilded"] .. " x14"
        },
        {
            10,
            701,
            L["gearTrack_Hero"] .. " 3/6",
            707,
            L["gearTrack_Myth"] .. " 1/6",
            crestIcons["gilded"] .. " x16"
        },
        {
            11,
            701,
            L["gearTrack_Hero"] .. " 3/6",
            707,
            L["gearTrack_Myth"] .. " 1/6",
            crestIcons["gilded"] .. " x18"
        },
        {
            "12+",
            701,
            L["gearTrack_Hero"] .. " 3/6",
            707,
            L["gearTrack_Myth"] .. " 1/6",
            crestIcons["gilded"] .. " x20"
        }
    }

end
