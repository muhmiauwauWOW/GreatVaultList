local addonName = ...
local _ = LibStub("LibLodash-1"):Get()

GreatVaultListDelvesLootListMixin  = CreateFromMixins(GreatVaultListLootListMixin);

GreatVaultListDelvesLootListMixin.tabName = string.format("%s Loot", "Delves")
GreatVaultListDelvesLootListMixin.sortOrder = 1


function GreatVaultListDelvesLootListMixin:OnLoad()
	GreatVaultListLootListMixin.OnLoad(self)
end

function GreatVaultListDelvesLootListMixin:BuildData()

    self:AddColumn("Delve Tier")
    self:AddColumn("Bountiful", true)
    self:AddColumn("Upgrade Level")
    self:AddColumn("Great Vault", true)
    self:AddColumn("Upgrade Level")


	self.ItemList.data = {
		{
			1,
			561,
			"Explorer 2/8",
			584,
			"Veteran 1/8"
		},
		{
			2, 
			564,
			"Explorer 3/8",        
			584,
			"Veteran 1/8"
		},
		{
			3, 
			571,
			"Adventurer 1/8",      
			587,
			"Veteran 2/8"
		},
		{
			4, 
			577,
			"Adventurer 3/8",      
			597,
			"Champion 1/8"
		},
		{
			5, 
			584,
			"Veteran 1/8",     
			603,
			"Champion 3/8"
		},
		{
			6, 
			590,
			"Veteran 3/8",     
			606,
			"Champion 4/8"
		},
		{
			7, 
			597,
			"Champion 1/8",        
			610,
			"Hero 1/6"
		},
		{
			8, 
			603,
			"Champion 3/8",        
			616,
			"Hero 3/6"
		},
		{
			9, 
			603,
			"Champion 3/8",        
			616,
			"Hero 3/6"
		},
		{
			10,
			603, 
			"Champion 3/8",        
			616,
			"Hero 3/6"
		},
		{
			11,
			603, 
			"Champion 3/8",        
			616, 
			"Hero 3/6"
		},
	}

end
