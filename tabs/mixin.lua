local addonName = ...
local L, _ = GreatVaultList:GetLibs()


GreatVaultListLootListMixin  = CreateFromMixins(GreatVaultListListMixin);

GreatVaultListLootListMixin.tabName = ""
GreatVaultListLootListMixin.sortOrder = 1

function GreatVaultListLootListMixin:OnLoad()
	GreatVaultListListMixin.OnLoad(self)
	self.i = 0
    self.itemlvl = 0

	self.columnConfig = {}
	self.columns = {}


	self:BuildData()
	self:init()

	GreatVaultListFrame:HookScript("OnLoad", function() 
		GreatVaultListFrame:AddTabFn(self.tabName, self); --Delves Item Level Loot Table
	end)
end

function GreatVaultListLootListMixin:OnShow()
    self.itemlvl = select(2, GetAverageItemLevel())
	self:GetParent():UpdateSize(self.width0);
	self.ItemList:SetTableBuilderLayout(self:GetBrowseListLayout(self, self.ItemList, true), self.columnConfig);
    self.ItemList:RefreshScrollFrame();
end


function GreatVaultListLootListMixin:init()
	self.columnConfig = self:calcAutoWidthColumns(self.ItemList.data, self.columnConfig, self.columns)

	local width = 15 + (_.size(self.columnConfig) * 1)
    _.forEach(self.columnConfig, function(entry)
        width = width + (entry.width or 0)
    end)

	self.width = width
    --self.ItemList:SetTableBuilderLayout(self:GetBrowseListLayout(self, self.ItemList, true), self.columnConfig);
end


function GreatVaultListLootListMixin:colorItemLvl(itemlvl, ilvl)
    return GreatVaultList.Util:colorItemLvl(itemlvl, ilvl, 10, 30)
end


function GreatVaultListLootListMixin:AddColumn(name, color, tooltip)
	self.i = self.i + 1
	local key = "col" .. self.i
	self.columnConfig[key] =  self:getColconfig(name, color, tooltip)
	table.insert(self.columns, key)
end

function GreatVaultListLootListMixin:getColconfig(name, color, tooltip)
	local config = {}
	config.index = self.i
	config.width = 50
	config.autoWidth = true
	config.header = {text = name, canSort = false}
	config.colType = "fill"
    config.selected = false
    config.tooltip = tooltip or nil

	if color then 
		config.populate = function(s, number)
			if type(number) ~= "number" then return number end
			return self:colorItemLvl(self.itemlvl, number)
		end
	end
	return config
end