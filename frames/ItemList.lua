local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()





local TableBuilderMixin = {};

function TableBuilderMixin:AddColumnInternal(owner, sortOrder, cellTemplate, tooltip, ...)
	local column = self:AddColumn();

	if sortOrder then
		column:ConstructHeader("BUTTON", "GreatVaultListTableHeaderStringTemplate", owner, nil, sortOrder, tooltip);
	end

	column:ConstructCells("FRAME", cellTemplate, owner, ...);
	return column;
end

function TableBuilderMixin:AddFillColumn(owner, padding, fillCoefficient, leftCellPadding, rightCellPadding, sortOrder, cellTemplate, tooltip, ...)
	local column = self:AddColumnInternal(owner, sortOrder, cellTemplate, tooltip, ...);
	column:SetFillConstraints(fillCoefficient, padding);
	column:SetCellPadding(leftCellPadding, rightCellPadding);
	return column;
end


function TableBuilderMixin:AddFixedWidthColumn(owner, padding, width, leftCellPadding, rightCellPadding, sortOrder, cellTemplate, tooltip, ...)
	local column = self:AddColumnInternal(owner, sortOrder, cellTemplate, tooltip, ...);
	column:SetFixedConstraints(width, padding);
	column:SetCellPadding(leftCellPadding, rightCellPadding);
	return column;
end




local ItemListMixin = {}
GreatVaultListItemListMixin = ItemListMixin

function ItemListMixin:OnLoad()
	self.data = {}
	self.ScrollBox:RegisterCallback(ScrollBoxListMixin.Event.OnScroll, self.OnScrollBoxScroll, self);

	self.ResultsText:SetText(L["ResultsText"])

	local xOffset = 0;
	local yOffset = -20;
	self.Background:SetAtlas("auctionhouse-background-index", true);
	self.Background:SetPoint("TOPLEFT", xOffset + 3, yOffset - 3);
end

function ItemListMixin:SetTableBuilderLayout(tableBuilderLayoutFunction, columnConfig)
	self.tableBuilderLayoutFunction = tableBuilderLayoutFunction;
	self.tableBuilderLayoutDirty = true;
	self.columnConfig = columnConfig

	if self.isInitialized and self:IsShown() then
		self:UpdateTableBuilderLayout();
	end
end

function ItemListMixin:UpdateTableBuilderLayout()
	if self.tableBuilderLayoutDirty then
		self.tableBuilder:Reset();
		self.tableBuilderLayoutFunction(self.tableBuilder);
		self.tableBuilder:SetTableWidth(self.ScrollBox:GetWidth());
		self.tableBuilder:Arrange();
		self.tableBuilderLayoutDirty = false;
	end
end

function ItemListMixin:Init()
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
		factory(self.lineTemplate or "GreatVaultListTableLineTemplate", Initializer);
	end);

	ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, view);
    
	local tableBuilder = CreateTableBuilder(nil, TableBuilderMixin);
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

function ItemListMixin:OnShow()
	self:Init();
	self:UpdateTableBuilderLayout();
end

function ItemListMixin:DirtyScrollFrame()
	self.scrollFrameDirty = true;
end

function ItemListMixin:RefreshScrollFrame()
	self.scrollFrameDirty = false;

	if not self.isInitialized or not self:IsShown() then
		return;
	end

	local numResults = self.getNumEntries();
	local dataProvider = CreateIndexRangeDataProvider(numResults);
	self.ScrollBox:SetDataProvider(dataProvider, ScrollBoxConstants.RetainScrollPosition);
	self.ResultsText:SetShown(numResults == 0);
end

function ItemListMixin:OnScrollBoxScroll(scrollPercentage, visibleExtentPercentage, panExtentPercentage)

end

function ItemListMixin:GetHeaderContainer()
	return self.HeaderContainer;
end
