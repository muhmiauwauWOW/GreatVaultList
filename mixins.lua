local _ = LibStub("LibLodash-1"):Get()





GreatVaultListTableCellTextMixin = CreateFromMixins(TableBuilderCellMixin);

function GreatVaultListTableCellTextMixin:Init(owner, dataIndex, columns, columnConfig, width)
    self.columns = columns or {}
    self.columnConfig = columnConfig or {}
    self.width = width
end

function GreatVaultListTableCellTextMixin:PopulateFn(rowData, dataIndex, idx)
    idx = idx or 1
    local text
    local fn = _.get(self.columnConfig, {self.columns[dataIndex], "populate"})
    if fn then 
        text = fn(self, rowData[dataIndex], idx)
    else 
        text = rowData[dataIndex]
    end

    if not text then 
        local emptyStr = _.get(self.columnConfig, {self.columns[dataIndex], "emptyStr", idx}, _.get(self.columnConfig, {self.columns[dataIndex], "emptyStr"}, "-"))
        text = GRAY_FONT_COLOR:WrapTextInColorCode(emptyStr)
    end
    return tostring(text)
end

function GreatVaultListTableCellTextMixin:Populate(rowData, dataIndex)
    self.Text:SetText(self:PopulateFn(rowData, dataIndex))
end


GreatVaultListTableCellTripleTextMixin = CreateFromMixins(GreatVaultListTableCellTextMixin);



function GreatVaultListTableCellTripleTextMixin:Populate(rowData, dataIndex)
    _.forEach({"Text1", "Text2", "Text3"}, function(entry, idx)
        self[entry]:SetWidth(math.floor(self.width/3))
        self[entry].Text:SetJustifyH("CENTER")
        self[entry].Text:SetText(self:PopulateFn(rowData, dataIndex, idx))
    end)
end











GreatVaultListSortOrderState = tInvert({
	"None",
	"PrimarySorted",
	"PrimaryReversed",
	"Sorted",
	"Reversed",
});

GreatVaultListTableHeaderStringMixin = CreateFromMixins(TableBuilderElementMixin);

function GreatVaultListTableHeaderStringMixin:OnClick()
	self.owner:SetSortOrder(self.sortOrder);
	self:UpdateArrow();
end

function GreatVaultListTableHeaderStringMixin:Init(owner, headerText, sortOrder)
	self:SetText(headerText);

	local interactiveHeader = owner.RegisterHeader and sortOrder ~= nil;
	self:SetEnabled(interactiveHeader);
	self.owner = owner;
	self.sortOrder = sortOrder;

	if interactiveHeader then
		owner:RegisterHeader(self);
		self:UpdateArrow();
	else
		self.Arrow:Hide();
	end
end

function GreatVaultListTableHeaderStringMixin:UpdateArrow()
	local sortOrderState = self.owner:GetSortOrderState(self.sortOrder);
	self:SetArrowState(sortOrderState);
end

function GreatVaultListTableHeaderStringMixin:SetArrowState(sortOrderState)
	self.Arrow:SetShown(sortOrderState == GreatVaultListSortOrderState.PrimarySorted or sortOrderState == GreatVaultListSortOrderState.PrimaryReversed);
	if sortOrderState == GreatVaultListSortOrderState.PrimarySorted then
		self.Arrow:SetTexCoord(0, 1, 1, 0);
	elseif sortOrderState == GreatVaultListSortOrderState.PrimaryReversed then
		self.Arrow:SetTexCoord(0, 1, 0, 1);
	end
end






GreatVaultListMixin = {}



function GreatVaultListMixin:OnLoad()
	TabSystemOwnerMixin.OnLoad(self);
    self:SetTabSystem(self.TabSystem);
    self.List = self:AddNamedTab("List", self.BrowseResultsFrame);
   -- self.Options = self:AddNamedTab("Options", self.OptionsFrame);

    self:SetTab(self.List);

    self:SetPortraitToClassIcon(C_CreatureInfo.GetClassInfo(PlayerUtil.GetClassID()).classFile);


    self.width = 800

    --self:init()
    local dragarea = GreatVaultListFrame.Drag
    GreatVaultListFrame:SetMovable(true)
    GreatVaultListFrame:EnableMouse(true)
    dragarea:EnableMouse(true)
    dragarea:RegisterForDrag("LeftButton")
    dragarea:SetScript("OnDragStart", function(self, button)
        GreatVaultListFrame:StartMoving()
    end)

    dragarea:SetScript("OnDragStop", function(self)
        GreatVaultListFrame:StopMovingOrSizing()
    end)
end


function GreatVaultListMixin:OnShow()
    self:UpdateTabs();
    self:UpdateSize();

    self.BrowseResultsFrame.ItemList:RefreshScrollFrame();
end

function GreatVaultListMixin:UpdateTabs()
	self.TabSystem:SetTabShown(self.List, true);

    
end



function GreatVaultListMixin:UpdateSize(width)
    self.width = width or self.width

    if not  GreatVaultList.db then return  end 
    local height = (GreatVaultList.db.global.Options.lines * 21) + 70 + 19  + 7
    self:SetWidth(self.width)
    self:SetHeight(height)
end


function GreatVaultListMixin:OnHide()
end


function GreatVaultListMixin:OnEvent()
end








GreatVaultListTableBuilderMixin = {};

function GreatVaultListTableBuilderMixin:AddColumnInternal(owner, sortOrder, cellTemplate, ...)
	local column = self:AddColumn();

	if sortOrder then
		column:ConstructHeader("BUTTON", "GreatVaultListTableHeaderStringTemplate", owner, owner.columns[sortOrder], sortOrder);
	end

	column:ConstructCells("FRAME", cellTemplate, owner, ...);

	return column;
end

function GreatVaultListTableBuilderMixin:AddFillColumn(owner, padding, fillCoefficient, leftCellPadding, rightCellPadding, sortOrder, cellTemplate, ...)
	local column = self:AddColumnInternal(owner, sortOrder, cellTemplate, ...);
	column:SetFillConstraints(fillCoefficient, padding);
	column:SetCellPadding(leftCellPadding, rightCellPadding);
	return column;
end


function GreatVaultListTableBuilderMixin:AddFixedWidthColumn(owner, padding, width, leftCellPadding, rightCellPadding, sortOrder, cellTemplate, ...)
	local column = self:AddColumnInternal(owner, sortOrder, cellTemplate, ...);
	column:SetFixedConstraints(width, padding);
	column:SetCellPadding(leftCellPadding, rightCellPadding);
	return column;
end






GreatVaultListItemListLineMixin = {};

function GreatVaultListItemListLineMixin:OnClick(button)
	-- Overrides register for right click as well, ensure this is a left click. 
	if button == "LeftButton" then
		self:GetItemList():SetSelectedEntry(self.rowData);
	end
end


function GreatVaultListItemListLineMixin:OnEnter()
	self.HighlightTexture:Show();
end

function GreatVaultListItemListLineMixin:OnLeave()
	self.HighlightTexture:Hide();
end

function GreatVaultListItemListLineMixin:GetItemList()
	return self:GetParent():GetParent():GetParent();
end

function GreatVaultListItemListLineMixin:GetRowData()
	return self.rowData;
end








GreatVaultListBackgroundMixin = {};

function GreatVaultListBackgroundMixin:OnLoad()
	local xOffset = self.backgroundXOffset or 0;
	local yOffset = self.backgroundYOffset or 0;
	self.Background:SetAtlas(self.backgroundAtlas, true);
	self.Background:SetPoint("TOPLEFT", xOffset + 3, yOffset - 3);

	self.NineSlice:ClearAllPoints();
	self.NineSlice:SetPoint("TOPLEFT", xOffset, yOffset);
	self.NineSlice:SetPoint("BOTTOMRIGHT");
end









GreatVaultListItemListMixin = {};

function GreatVaultListItemListMixin:OnLoad()
	GreatVaultListBackgroundMixin.OnLoad(self);
	self.NineSlice:SetPoint("BOTTOMRIGHT", -22, 0);
	self.ScrollBox:RegisterCallback(ScrollBoxListMixin.Event.OnScroll, self.OnScrollBoxScroll, self);
end

function GreatVaultListItemListMixin:SetDataProvider(getEntry, getNumEntries)
	self.getEntry = getEntry;
	self.getNumEntries = getNumEntries;

	if self.tableBuilder then
		self.tableBuilder:SetDataProvider(self.getEntry);
	end
end

function GreatVaultListItemListMixin:SetTableBuilderLayout(tableBuilderLayoutFunction)
	self.tableBuilderLayoutFunction = tableBuilderLayoutFunction;
	self.tableBuilderLayoutDirty = true;

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

function GreatVaultListItemListMixin:SetSelectionCallback(selectionCallback)
	self.selectionCallback = selectionCallback;
end

function GreatVaultListItemListMixin:SetHighlightCallback(highlightCallback)
	self.highlightCallback = highlightCallback;
end

function GreatVaultListItemListMixin:SetLineTemplate(lineTemplate, ...)
	self.lineTemplate = lineTemplate;
	self.initArgs = { ... };
end

function GreatVaultListItemListMixin:SetCustomError(errorText)
	self.ResultsText:Show();
	self.ResultsText:SetText(errorText);
end

function GreatVaultListItemListMixin:Init()
	if self.isInitialized then
		return;
	end

	local view = CreateScrollBoxListLinearView();
	view:SetElementFactory(function(factory, elementData)
		local function Initializer(button, elementData)
            if  GreatVaultListFrame.BrowseResultsFrame.currentPlayer == elementData then 
                button.CurrentTexture:Show()
            end
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

	if self.getEntry then
		self.tableBuilder:SetDataProvider(self.getEntry);
	end

	self.isInitialized = true;
end

function GreatVaultListItemListMixin:SetLineOnEnterCallback(callback)
	self.lineOnEnterCallback = callback;
end

function GreatVaultListItemListMixin:OnEnterListLine(line, rowData)
	if self.lineOnEnterCallback then
		self.lineOnEnterCallback(line, rowData);
	end
end

function GreatVaultListItemListMixin:SetLineOnLeaveCallback(callback)
	self.lineOnLeaveCallback = callback;
end

function GreatVaultListItemListMixin:OnLeaveListLine(line, rowData)
	if self.lineOnLeaveCallback then
		self.lineOnLeaveCallback(line, rowData);
	end
end

function GreatVaultListItemListMixin:SetSelectedEntry(rowData)
	if self.selectionCallback then
		if not self.selectionCallback(rowData) then
			return;
		end
	end

	self.selectedRowData = rowData;
	self:DirtyScrollFrame();
end

function GreatVaultListItemListMixin:GetSelectedEntry()
	return self.selectedRowData;
end

function GreatVaultListItemListMixin:OnShow()
	self:Init();
	self:UpdateTableBuilderLayout();
end

function GreatVaultListItemListMixin:OnUpdate()
	if self.scrollFrameDirty then
		self:RefreshScrollFrame();
	end
end

function GreatVaultListItemListMixin:Reset()
	self.ScrollBox:ScrollToBegin();
	self:RefreshScrollFrame();
end

function GreatVaultListItemListMixin:GetScrollBoxDataIndexBegin()
	return self.ScrollBox:GetDataIndexBegin();
end

function GreatVaultListItemListMixin:DirtyScrollFrame()
	self.scrollFrameDirty = true;
end

function GreatVaultListItemListMixin:RefreshScrollFrame()
	self.scrollFrameDirty = false;

	if not self.isInitialized or not self:IsShown() then
		return;
	end

	if not self.getNumEntries then
		error("Data provider not set. Use GreatVaultListItemListMixin:SetDataProvider.");
		return;
	end

	local numResults = self.getNumEntries();
    
	local dataProvider = CreateIndexRangeDataProvider(numResults);
	self.ScrollBox:SetDataProvider(dataProvider, ScrollBoxConstants.RetainScrollPosition);
	
	self:CallRefreshCallback();
end

function GreatVaultListItemListMixin:CallRefreshCallback()
	-- if self.refreshCallback ~= nil then
	-- 	local lastDisplayedEntry = self.ScrollBox:GetDataIndexEnd();
	-- 	self.refreshCallback(lastDisplayedEntry);
	-- end
end

function GreatVaultListItemListMixin:OnScrollBoxScroll(scrollPercentage, visibleExtentPercentage, panExtentPercentage)
	self:CallRefreshCallback();
end

function GreatVaultListItemListMixin:GetHeaderContainer()
	return self.HeaderContainer;
end














GreatVaultListBrowseResultsFrameMixin = {};


function GreatVaultListBrowseResultsFrameMixin:GetBrowseListLayout(owner, itemList)

    local function LayoutBrowseListTableBuilder(tableBuilder)
        tableBuilder:SetColumnHeaderOverlap(2);
        tableBuilder:SetHeaderContainer(itemList:GetHeaderContainer());

        _.forEach(self.columns, function(colName, idx)
            local width = _.get(self.columnConfig, {colName, "width"})
            local headerText = _.get(self.columnConfig, {colName, "header", "text"})
            local xpadding = _.get(self.columnConfig, {colName, "xpadding"}, 14)
            local ypadding = _.get(self.columnConfig, {colName, "ypadding"}, 14)
            local template = _.get(self.columnConfig, {colName, "template"}, "GreatVaultListTableCellTextTemplate")
            local col = tableBuilder:AddFixedWidthColumn(owner, 0, width, xpadding, ypadding, idx, template, idx, self.columns, self.columnConfig, width);
            col:GetHeaderFrame():SetText(headerText);
        end)
    end

    return LayoutBrowseListTableBuilder;
end

function GreatVaultListBrowseResultsFrameMixin:OnLoad()
	

end

function GreatVaultListBrowseResultsFrameMixin:init(columns, data, columnConfig)
    self.columns = columns
    self.data = data
    self.columnConfig = columnConfig


    self.currentPlayer = 0
    local fidx =  _.findIndex(self.columns, function(entry)
        return entry == "character"
    end)

    self.currentPlayer =  _.findIndex(self.data, function(entry)
        return entry[fidx] == UnitName("player")
    end)


	local function GetNumEntries()
		return #self.data;
	end

	local function GetEntry(index)
		return self.data[index];
	end
   

    local width = 15 + (_.size(self.columnConfig) * 1)
    _.forEach(self.columnConfig, function(entry)
        width = width + (entry.width or 0)
    end)

    self:GetParent():UpdateSize(width);



	self.ItemList:SetDataProvider(GetEntry, GetNumEntries);
    self.ItemList:SetTableBuilderLayout(self:GetBrowseListLayout(self, self.ItemList));
    self.ItemList:DirtyScrollFrame();
    self.ItemList:RefreshScrollFrame(); 

end

function GreatVaultListBrowseResultsFrameMixin:update(columns, data, columnConfig)
    self.columns = columns
    self.data = data
    self.columnConfig = columnConfig


    local width = 15 + (_.size(self.columnConfig) * 1)
    _.forEach(self.columnConfig, function(entry)
        width = width + (entry.width or 0)
    end)

    self:GetParent():UpdateSize(width);

    self.ItemList:SetTableBuilderLayout(self:GetBrowseListLayout(self, self.ItemList));   
end

