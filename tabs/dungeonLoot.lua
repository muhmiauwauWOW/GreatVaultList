local addonName = ...
local _ = LibStub("LibLodash-1"):Get()


GreatVaultListDungeonLootListMixin  = CreateFromMixins(GreatVaultListLootListMixin);

GreatVaultListDungeonLootListMixin.tabName = string.format("%s Loot", DUNGEONS)

function GreatVaultListDungeonLootListMixin:OnLoad()
	GreatVaultListLootListMixin.OnLoad(self)
end

function GreatVaultListDungeonLootListMixin:BuildData()
	
	self:AddColumn("Level")
	self:AddColumn("EoD", true)
	self:AddColumn("Upgrade Level")
	self:AddColumn("Great Vault", true)
	self:AddColumn("Upgrade Level")
	

	self.ItemList.data = {
		{ 
			"Heroic",
			580,
			"Adventurer 4/8",
			593,
			"Veteran 4/8"
		},
		{ 
			"Mythic",
			597,
			"Veteran 4/8",
			603,
			"Champion 3/8"
		},
		{ 
			2,
			597,
			"Champion 1/8",
			606,
			"Champion 4/8"
		},
		{ 
			3,
			597,
			"Champion 1/8",
			610,
			"Hero 1/6"
		},
		{ 
			4,
			600,
			"Champion 2/8",
			610,
			"Hero 1/6"
		},
		{ 
			5,
			603,
			"Champion 3/8",
			613,
			"Hero 2/6"
		},
		{ 
			6,
			606,
			"Champion 4/8",
			613,
			"Hero 2/6"
		},
		{ 
			7,
			610,
			"Hero 1/6",
			616,
			"Hero 3/6"
		},
		{ 
			8,
			610,
			"Hero 1/6",
			619,
			"Hero 4/6"
		},
		{ 
			9,
			613,
			"Hero 1/6",
			619,
			"Hero 4/6"
		},
		{ 
			10,
			613,
			"Hero 1/6",
			623,
			"Myth 1/6"
		}
	}

end
