local addonName = ...
local L, _ = GreatVaultList:GetLibs()


local dungeonLootMixin  = CreateFromMixins(GreatVaultListLootListMixin);
GreatVaultListDungeonLootListMixin = dungeonLootMixin

dungeonLootMixin.tabName = string.format(L["tabLoot_name"], DUNGEONS)
dungeonLootMixin.sortOrder = 4

function dungeonLootMixin:OnLoad()
	GreatVaultListLootListMixin.OnLoad(self)
end

function dungeonLootMixin:BuildData()
	
	self:AddColumn(L["dungeonLoot_col1"])
	self:AddColumn(L["tabLoot_ilvl"], true, L["dungeonLoot_col2"])
	self:AddColumn(L["tabLoot_upgradelvl"], true, L["dungeonLoot_col2"])
	self:AddColumn(L["tabLoot_ilvl"], true, L["tabLoot_greatVault"])
	self:AddColumn(L["tabLoot_upgradelvl"], false, L["tabLoot_greatVault"])


	self.ItemList.data = {
		{ 
			PLAYER_DIFFICULTY2,
			580,
			L["gearTrack_Adventurer"] .. " 4/8",
			593,
			L["gearTrack_Veteran"] .. " 4/8"
		},
		{ 
			PLAYER_DIFFICULTY6,
			597,
			L["gearTrack_Veteran"] .. " 4/8",
			603,
			L["gearTrack_Champion"] .. "  3/8"
		},
		{ 
			2,
			597,
			L["gearTrack_Champion"] .. "  1/8",
			606,
			L["gearTrack_Champion"] .. "  4/8"
		},
		{ 
			3,
			597,
			L["gearTrack_Champion"] .. "  1/8",
			610,
			L["gearTrack_Hero"] .. "  1/6"
		},
		{ 
			4,
			600,
			L["gearTrack_Champion"] .. "  2/8",
			610,
			L["gearTrack_Hero"] .. "  1/6"
		},
		{ 
			5,
			603,
			L["gearTrack_Champion"] .. "  3/8",
			613,
			L["gearTrack_Hero"] .. "  2/6"
		},
		{ 
			6,
			606,
			L["gearTrack_Champion"] .. "  4/8",
			613,
			L["gearTrack_Hero"] .. "  2/6"
		},
		{ 
			7,
			610,
			L["gearTrack_Hero"] .. "  1/6",
			616,
			L["gearTrack_Hero"] .. "  3/6"
		},
		{ 
			8,
			610,
			L["gearTrack_Hero"] .. "  1/6",
			619,
			L["gearTrack_Hero"] .. "  4/6"
		},
		{ 
			9,
			613,
			L["gearTrack_Hero"] .. "  2/6",
			619,
			L["gearTrack_Hero"] .. "  4/6"
		},
		{ 
			10,
			613,
			L["gearTrack_Hero"] .. "  2/6",
			623,
			L["gearTrack_Myth"] .. "  1/6"
		}
	}

end
