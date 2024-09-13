local addonName = ...
local _ = LibStub("LibLodash-1"):Get()


GreatVaultListRaidLootListMixin  = CreateFromMixins(GreatVaultListLootListMixin);

GreatVaultListRaidLootListMixin.tabName = string.format("%s Loot", RAIDS)
GreatVaultListRaidLootListMixin.sortOrder = 5

function GreatVaultListRaidLootListMixin:OnLoad()
	GreatVaultListLootListMixin.OnLoad(self)
end

function GreatVaultListRaidLootListMixin:BuildData()



	self:AddColumn("Difficulty and Type")
	self:AddColumn("Bosses 1-2", true)
	self:AddColumn("Bosses 3-4", true)
	self:AddColumn("Bosses 5-6", true)
	self:AddColumn("Bosses 7-8", true)

	self.ItemList.data = {
		{
			"LFR Regular",
			584,	
			587,	
			590,	
			593
		},
		{
			"LFR Very Rare",	
			nil,	
			600,	
			600,	
			600
		},
		{
			"Normal Regular",
			597,	
			600,	
			603,	
			606
		},
		{
			"Normal Very Rare",	
			nil,	
			613,	
			613,	
			613
		},
		{
			"Heroic Regular",
			610,	
			613,	
			616,	
			619
		},
		{
			"Heroic Very Rare",	
			nil,	
			626,	
			626,	
			626
		},
		{
			"Mythic Regular",
			623,	
			626,	
			629,	
			632
		},
		{
			"Mythic Very Rare",	
			nil,	
			639,	
			639,	
			639
		}
	}


end
