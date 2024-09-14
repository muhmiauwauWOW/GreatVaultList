local addonName = ...
local _ = LibStub("LibLodash-1"):Get()
local L, _ = GreatVaultList:GetLibs()

GreatVaultListRaidLootListMixin  = CreateFromMixins(GreatVaultListLootListMixin);

GreatVaultListRaidLootListMixin.tabName = string.format(L["tabLoot_name"], RAIDS)
GreatVaultListRaidLootListMixin.sortOrder = 5

function GreatVaultListRaidLootListMixin:OnLoad()
	GreatVaultListLootListMixin.OnLoad(self)
end

function GreatVaultListRaidLootListMixin:BuildData()



	self:AddColumn(L["raidLoot_col1"])
	self:AddColumn(string.format(L["raidLoot_bosses"], "1-2"), true)
	self:AddColumn(string.format(L["raidLoot_bosses"], "3-4"), true)
	self:AddColumn(string.format(L["raidLoot_bosses"], "5-6"), true)
	self:AddColumn(string.format(L["raidLoot_bosses"], "7-8"), true)

	self.ItemList.data = {
		{
			string.format("%s %s", "LFR", L["raidLoot_Regular"]),
			584,	
			587,	
			590,	
			593
		},
		{
			string.format("%s %s", "LFR", L["raidLoot_VeryRare"]),
			nil,	
			600,	
			600,	
			600
		},
		{
			string.format("%s %s", PLAYER_DIFFICULTY1, L["raidLoot_Regular"]),
			597,	
			600,	
			603,	
			606
		},
		{
			string.format("%s %s", PLAYER_DIFFICULTY1, L["raidLoot_VeryRare"]),
			nil,	
			613,	
			613,	
			613
		},
		{
			string.format("%s %s", PLAYER_DIFFICULTY2, L["raidLoot_Regular"]),
			610,	
			613,	
			616,	
			619
		},
		{
			string.format("%s %s", PLAYER_DIFFICULTY2, L["raidLoot_VeryRare"]),
			nil,	
			626,	
			626,	
			626
		},
		{
			string.format("%s %s", PLAYER_DIFFICULTY6, L["raidLoot_Regular"]),
			623,	
			626,	
			629,	
			632
		},
		{
			string.format("%s %s", PLAYER_DIFFICULTY6, L["raidLoot_VeryRare"]),
			nil,	
			639,	
			639,	
			639
		}
	}


end
