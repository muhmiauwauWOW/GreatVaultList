local addonName = ...
local L, _ = GreatVaultList:GetLibs()


GreatVaultListDungeonLootListMixin  = CreateFromMixins(GreatVaultListLootListMixin);

GreatVaultListDungeonLootListMixin.tabName = string.format(L["tabLoot_name"], DUNGEONS)
GreatVaultListDungeonLootListMixin.sortOrder = 4

function GreatVaultListDungeonLootListMixin:OnLoad()
	GreatVaultListLootListMixin.OnLoad(self)
end

function GreatVaultListDungeonLootListMixin:BuildData()
	
	self:AddColumn(L["dungeonLoot_col1"])
	self:AddColumn(L["dungeonLoot_col2"], true)
	self:AddColumn(L["tabLoot_upgradelvl"])
	self:AddColumn(L["tabLoot_greatVault"], true)
	self:AddColumn(L["tabLoot_upgradelvl"])


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
			L["gearTrack_Hero"] .. "  1/6",
			619,
			L["gearTrack_Hero"] .. "  4/6"
		},
		{ 
			10,
			613,
			L["gearTrack_Hero"] .. "  1/6",
			623,
			L["gearTrack_Myth"] .. "  1/6"
		}
	}

end
