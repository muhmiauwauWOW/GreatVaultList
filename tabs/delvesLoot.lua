local addonName = ...
local _ = LibStub("LibLodash-1"):Get()

GreatVaultListDelvesLootListMixin  = CreateFromMixins(GreatVaultListListMixin);

function GreatVaultListDelvesLootListMixin:OnLoad()
	GreatVaultListListMixin.OnLoad(self)
	self:BuildDataAndInit()
	
	GreatVaultListFrame:HookScript("OnLoad", function() 
		GreatVaultListFrame:AddTabFn("Delves Loot", self); --Delves Item Level Loot Table
	end)
end

function GreatVaultListDelvesLootListMixin:OnShow()
	self.reverseSort = true
	self:SetSortOrder(1)
	self:GetParent():UpdateSize(self.width);
end


function GreatVaultListDelvesLootListMixin:init(columns, data, columnConfig)
	local asserttext = "variable \"%s\" size is 0"
	GreatVaultList:assert(_.size(columns) > 0, "GreatVaultListListMixin:init", asserttext, "columns")
	GreatVaultList:assert(_.size(data) > 0, "GreatVaultListListMixin:init", asserttext, "data")
	GreatVaultList:assert(_.size(columnConfig) > 0, "GreatVaultListListMixin:init", asserttext, "columnConfig")

    self.columns = columns
	self.ItemList.data = data
    self.columnConfig = columnConfig
	self.columnConfig = self:calcAutoWidthColumns(self.ItemList.data, self.columnConfig, self.columns)

	local width = 15 + (_.size(self.columnConfig) * 1)
    _.forEach(self.columnConfig, function(entry)
        width = width + (entry.width or 0)
    end)

	self.width = width
    self.ItemList:SetTableBuilderLayout(self:GetBrowseListLayout(self, self.ItemList), self.columnConfig);
end


function GreatVaultListDelvesLootListMixin:BuildDataAndInit()
	local cols = {}

	local i = 0
	local function getColconfig(name, width)
		i = i + 1
		table.insert(cols, "col" .. i)
		local config = {}
		config.index = i
		config.width = 40
		config.autoWidth = true
		config.header = {key = name, text = name, width = 120, canSort = true}
		config.colType = "fill"
		return config
	end


	local colConfig = {
		col1 = getColconfig("Delve Tier Level",1),
		col2 = getColconfig("Bountiful Delve Rewards",1),
		col3 = getColconfig("Initial Upgrade Level",2),
		col4 = getColconfig("Great Vault",1),
		col5 = getColconfig("Initial Upgrade Level",2)
	}


	local data = {
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

	GreatVaultListFrame.DelvesLootList:init(cols, data, colConfig)
end