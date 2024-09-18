local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()

GreatVaultListItemListMixin = {};

function GreatVaultListItemListMixin:OnLoad()
	self.data = {}
	self.ScrollBox:RegisterCallback(ScrollBoxListMixin.Event.OnScroll, self.OnScrollBoxScroll, self);

	self.ResultsText:SetText(L["ResultsText"])

	local xOffset = 0;
	local yOffset = -20;
	self.Background:SetAtlas("auctionhouse-background-index", true);
	self.Background:SetPoint("TOPLEFT", xOffset + 3, yOffset - 3);
end

function GreatVaultListItemListMixin:SetTableBuilderLayout(tableBuilderLayoutFunction, columnConfig)
	self.tableBuilderLayoutFunction = tableBuilderLayoutFunction;
	self.tableBuilderLayoutDirty = true;
	self.columnConfig = columnConfig

	if self.isInitialized and self:IsShown() then
		self:UpdateTableBuilderLayout();
	end
end

function GreatVaultListItemListMixin:UpdateTableBuilderLayout()
	if self.tableBuilderLayoutDirty then
		self.tableBuilder:Reset();
		self.tableBuilderLayoutFunction(self.tableBuilder);
		self.tableBuilder:SetTableWidth(self.ScrollBox:GetWidth());
		self.tableBuilder:Arrange();
		self.tableBuilderLayoutDirty = false;
	end
end

function GreatVaultListItemListMixin:Init()
	if self.isInitialized then
		return;
	end

	local view = CreateScrollBoxListLinearView();
	view:SetElementFactory(function(factory, elementData)
		local function Initializer(button, elementData)
			local entry = self.getEntry(elementData)
			button.CurrentTexture:SetShown(entry.selected)
			button:SetEnabled(true);
		end
		factory(self.lineTemplate or "GreatVaultListItemListLineTemplate", Initializer);
	end);

	ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, view);
    
	local tableBuilder = CreateTableBuilder(nil, GreatVaultListTableBuilderMixin);
	self.tableBuilder = tableBuilder;

	local function ElementDataTranslator(elementData)
		return elementData;
	end;
	ScrollUtil.RegisterTableBuilder(self.ScrollBox, tableBuilder, ElementDataTranslator);


	self.getNumEntries = function()
		return #self.data;
	end

	self.getEntry = function(index)
		return self.data[index];
	end

	if self.tableBuilder then
		self.tableBuilder:SetDataProvider(self.getEntry);
	end

	self.isInitialized = true;
end

function GreatVaultListItemListMixin:OnShow()
	self:Init();
	self:UpdateTableBuilderLayout();
end

function GreatVaultListItemListMixin:DirtyScrollFrame()
	self.scrollFrameDirty = true;
end

function GreatVaultListItemListMixin:RefreshScrollFrame()
	self.scrollFrameDirty = false;

	if not self.isInitialized or not self:IsShown() then
		return;
	end

	local numResults = self.getNumEntries();
	local dataProvider = CreateIndexRangeDataProvider(numResults);
	self.ScrollBox:SetDataProvider(dataProvider, ScrollBoxConstants.RetainScrollPosition);
	self.ResultsText:SetShown(numResults == 0);
end

function GreatVaultListItemListMixin:OnScrollBoxScroll(scrollPercentage, visibleExtentPercentage, panExtentPercentage)

end

function GreatVaultListItemListMixin:GetHeaderContainer()
	return self.HeaderContainer;
end
