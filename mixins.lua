local addonName = ...
local AddOnInfo = {C_AddOns.GetAddOnInfo(addonName)}
local L, _ = GreatVaultList:GetLibs()





-- GreatVaultListTableCellBaseMixin = CreateFromMixins(TableBuilderCellMixin);

-- function GreatVaultListTableCellBaseMixin:Init(owner, dataIndex, columns, columnConfig, width)
--     self.columns = columns or {}
--     self.columnConfig = columnConfig or {}
--     self.width = width
-- end

-- function GreatVaultListTableCellBaseMixin:PopulateFn(rowData, dataIndex, idx)
--     idx = idx or 1
--     local text
--     local fn = _.get(self.columnConfig, {self.columns[dataIndex], "populate"})
--     if fn and type(fn) == "function" then 
--         text = fn(self, rowData[dataIndex], idx)
--     else 
--         text = rowData[dataIndex]
--     end


--     if not text then 
--         local emptyStr = _.get(self.columnConfig, {self.columns[dataIndex], "emptyStr", idx}, _.get(self.columnConfig, {self.columns[dataIndex], "emptyStr"}, "-"))
--         text = GRAY_FONT_COLOR:WrapTextInColorCode(emptyStr)
--     end
--     return tostring(text)
-- end

-- GreatVaultListTableCellTextMixin = CreateFromMixins(GreatVaultListTableCellBaseMixin);


-- function GreatVaultListTableCellTextMixin:Populate(rowData, dataIndex)
-- 	if not dataIndex then return end
--     self.Text:SetText(self:PopulateFn(rowData, dataIndex))
-- end


-- GreatVaultListTableCellTripleTextMixin = CreateFromMixins(GreatVaultListTableCellBaseMixin);

-- function GreatVaultListTableCellTripleTextMixin:Populate(rowData, dataIndex)
--     _.forEach({"Text1", "Text2", "Text3"}, function(entry, idx)
--         self[entry]:SetWidth(math.floor(self.width/3))
--         self[entry].Text:SetJustifyH("CENTER")
--         self[entry].Text:SetText(self:PopulateFn(rowData, dataIndex, idx))
--     end)
-- end



-- GreatVaultListTableCellIconMixin = CreateFromMixins(GreatVaultListTableCellBaseMixin);

-- function GreatVaultListTableCellIconMixin:Populate(rowData, dataIndex)
-- 	local fn = _.get(self.columnConfig, {self.columns[dataIndex], "populate"})
-- 	local icon = fn(rowData, rowData[dataIndex])
--     self.Icon:SetAtlas(icon)
-- end











GreatVaultListTableHeaderStringMixin = CreateFromMixins(TableBuilderElementMixin);



function GreatVaultListTableHeaderStringMixin:OnClick()
	if not self.interactiveHeader then return end
	self.owner:SetSortOrder(self.sortOrder);
end

function GreatVaultListTableHeaderStringMixin:OnEnter()
	if not self.tooltip then return end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:AddLine(self.tooltip);
	GameTooltip:Show();
end
function GreatVaultListTableHeaderStringMixin:OnLeave()
	if not self.tooltip then return end
	GameTooltip:Hide();
end


function GreatVaultListTableHeaderStringMixin:Init(owner, headerText, sortOrder, tooltip)
	self:SetText(headerText);

	local find = _.find(owner.sortHeaders, function(entry) return entry == sortOrder; end)
	self.interactiveHeader = owner.RegisterHeader and find;
	self.tooltip = tooltip
	self.owner = owner;
	self.sortOrder = sortOrder;

	

	if self.interactiveHeader then
		owner:RegisterHeader(self);
		self:UpdateArrow();
	else
		self:ClearHighlightTexture()
		self:ClearPushedTexture()
		self:SetPushedTextOffset(0, 0)
		self.Arrow:Hide();
	end
end

function GreatVaultListTableHeaderStringMixin:UpdateArrow(reverse)
	if self.owner.sort == self.sortOrder then 
		self:SetArrowState(reverse)
		self.Arrow:Show();
	else 
		self.Arrow:Hide();
	end
end

function GreatVaultListTableHeaderStringMixin:SetArrowState(reverse)
	if reverse then
		self.Arrow:SetTexCoord(0, 1, 1, 0);
	else 
		self.Arrow:SetTexCoord(0, 1, 0, 1);
	end
end






GreatVaultListMixin = {}



function GreatVaultListMixin:OnLoad()
	TabSystemOwnerMixin.OnLoad(self);
	self:SetTabSystem(self.TabSystem);
	self:AddTabFn("List", self.ListFrame);
	self:SetTab(1)


	self:SetPortraitTextureRaw("Interface\\AddOns\\GreatVaultList\\vault.png")
	self:GetPortrait():ClearAllPoints()
	self:GetPortrait():SetPoint("TOPLEFT", -2, 5)
	self:GetPortrait():SetSize(55, 55)

	self:SetTitle(AddOnInfo[2]) -- set addon name as title

    self.width = 800

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

	tinsert(UISpecialFrames, self:GetName())
end

function GreatVaultListMixin:OnShow()
    self:UpdateSize();
    self.ListFrame.ItemList:RefreshScrollFrame();
end


function GreatVaultListMixin:AddTabFn(key, ...)
    self:AddNamedTab(key, ...);
end


function GreatVaultListMixin:UpdateSize(width)
    self.width = width or self.width

	local tabsWidth = self.TabSystem:GetWidth() + 50
	self.width = tabsWidth > self.width and tabsWidth or self.width

    if not GreatVaultList.db then return  end 
    local height = (GreatVaultList.db.global.Options.lines * 21) + 60 + 19  + 7
    self:SetWidth(self.width)
    self:SetHeight(height)
end


function GreatVaultListMixin:OnHide()
end


function GreatVaultListMixin:RefreshScrollFrame()
	self.ListFrame.ItemList:RefreshScrollFrame();
end



function GreatVaultListMixin:GetState()
	if C_WeeklyRewards.HasAvailableRewards() then
		return "collect";
	end

	local rewardCheck = false
	_.forEach(Enum.WeeklyRewardChestThresholdType, function(type)
		if rewardCheck then return end
		rewardCheck = WeeklyRewardsUtil.HasUnlockedRewards(type)
	end)

	if rewardCheck then
		return "complete";
	end

	return "incomplete";
end




GreatVaultListListOpenVaultMixin = {}

function GreatVaultListListOpenVaultMixin:OnShow()
	local state = self:GetParent():GetParent():GetState()

	self.NormalTexture:SetShown(state ~= "incomplete");
	self.handlesTexture:SetShown(state == "incomplete");
	self.centerPlateTexture:SetShown(state == "incomplete");
	self.NormalTexture:SetDesaturated(state ~= "collect");
end

function GreatVaultListListOpenVaultMixin:OnClick()
	WeeklyRewardsFrame:SetShown(not WeeklyRewardsFrame:IsShown());
end




GreatVaultListTableBuilderMixin = {};

function GreatVaultListTableBuilderMixin:AddColumnInternal(owner, sortOrder, cellTemplate, tooltip, ...)
	local column = self:AddColumn();

	if sortOrder then
		column:ConstructHeader("BUTTON", "GreatVaultListTableHeaderStringTemplate", owner, nil, sortOrder, tooltip);
	end

	column:ConstructCells("FRAME", cellTemplate, owner, ...);
	return column;
end

function GreatVaultListTableBuilderMixin:AddFillColumn(owner, padding, fillCoefficient, leftCellPadding, rightCellPadding, sortOrder, cellTemplate, tooltip, ...)
	local column = self:AddColumnInternal(owner, sortOrder, cellTemplate, tooltip, ...);
	column:SetFillConstraints(fillCoefficient, padding);
	column:SetCellPadding(leftCellPadding, rightCellPadding);
	return column;
end


function GreatVaultListTableBuilderMixin:AddFixedWidthColumn(owner, padding, width, leftCellPadding, rightCellPadding, sortOrder, cellTemplate, tooltip, ...)
	local column = self:AddColumnInternal(owner, sortOrder, cellTemplate, tooltip, ...);
	column:SetFixedConstraints(width, padding);
	column:SetCellPadding(leftCellPadding, rightCellPadding);
	return column;
end






-- GreatVaultListItemListMixin = {};

-- function GreatVaultListItemListMixin:OnLoad()
-- 	self.data = {}
-- 	self.ScrollBox:RegisterCallback(ScrollBoxListMixin.Event.OnScroll, self.OnScrollBoxScroll, self);

-- 	self.ResultsText:SetText(L["ResultsText"])

-- 	local xOffset = 0;
-- 	local yOffset = -20;
-- 	self.Background:SetAtlas("auctionhouse-background-index", true);
-- 	self.Background:SetPoint("TOPLEFT", xOffset + 3, yOffset - 3);
-- end

-- function GreatVaultListItemListMixin:SetTableBuilderLayout(tableBuilderLayoutFunction, columnConfig)
-- 	self.tableBuilderLayoutFunction = tableBuilderLayoutFunction;
-- 	self.tableBuilderLayoutDirty = true;
-- 	self.columnConfig = columnConfig

-- 	if self.isInitialized and self:IsShown() then
-- 		self:UpdateTableBuilderLayout();
-- 	end
-- end

-- function GreatVaultListItemListMixin:UpdateTableBuilderLayout()
-- 	if self.tableBuilderLayoutDirty then
-- 		self.tableBuilder:Reset();
-- 		self.tableBuilderLayoutFunction(self.tableBuilder);
-- 		self.tableBuilder:SetTableWidth(self.ScrollBox:GetWidth());
-- 		self.tableBuilder:Arrange();
-- 		self.tableBuilderLayoutDirty = false;
-- 	end
-- end

-- function GreatVaultListItemListMixin:Init()
-- 	if self.isInitialized then
-- 		return;
-- 	end

-- 	local view = CreateScrollBoxListLinearView();
-- 	view:SetElementFactory(function(factory, elementData)
-- 		local function Initializer(button, elementData)
-- 			local entry = self.getEntry(elementData)
-- 			button.CurrentTexture:SetShown(entry.selected)
-- 			button:SetEnabled(true);
-- 		end
-- 		factory(self.lineTemplate or "GreatVaultListItemListLineTemplate", Initializer);
-- 	end);

-- 	ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, view);
    
-- 	local tableBuilder = CreateTableBuilder(nil, GreatVaultListTableBuilderMixin);
-- 	self.tableBuilder = tableBuilder;

-- 	local function ElementDataTranslator(elementData)
-- 		return elementData;
-- 	end;
-- 	ScrollUtil.RegisterTableBuilder(self.ScrollBox, tableBuilder, ElementDataTranslator);


-- 	self.getNumEntries = function()
-- 		return #self.data;
-- 	end

-- 	self.getEntry = function(index)
-- 		return self.data[index];
-- 	end

-- 	if self.tableBuilder then
-- 		self.tableBuilder:SetDataProvider(self.getEntry);
-- 	end

-- 	self.isInitialized = true;
-- end

-- function GreatVaultListItemListMixin:OnShow()
-- 	self:Init();
-- 	self:UpdateTableBuilderLayout();
-- end

-- function GreatVaultListItemListMixin:DirtyScrollFrame()
-- 	self.scrollFrameDirty = true;
-- end

-- function GreatVaultListItemListMixin:RefreshScrollFrame()
-- 	self.scrollFrameDirty = false;

-- 	if not self.isInitialized or not self:IsShown() then
-- 		return;
-- 	end

-- 	local numResults = self.getNumEntries();
-- 	local dataProvider = CreateIndexRangeDataProvider(numResults);
-- 	self.ScrollBox:SetDataProvider(dataProvider, ScrollBoxConstants.RetainScrollPosition);
-- 	self.ResultsText:SetShown(numResults == 0);
-- end

-- function GreatVaultListItemListMixin:OnScrollBoxScroll(scrollPercentage, visibleExtentPercentage, panExtentPercentage)

-- end

-- function GreatVaultListItemListMixin:GetHeaderContainer()
-- 	return self.HeaderContainer;
-- end





GreatVaultListListMixin = {};


function GreatVaultListListMixin:GetBrowseListLayout(owner, itemList, useFill)
	owner.headers = {}
	owner.sort = 1
	owner.reverseSort = false
	owner.sortHeaders = {}
    local function LayoutBrowseListTableBuilder(tableBuilder)
        tableBuilder:SetColumnHeaderOverlap(2);
        tableBuilder:SetHeaderContainer(itemList:GetHeaderContainer());

        _.forEach(self.columns, function(colName, idx)
            local width = _.get(self.columnConfig, {colName, "width"})
            local headerText = _.get(self.columnConfig, {colName, "header", "text"})
            local padding = _.get(self.columnConfig, {colName, "padding"}, GreatVaultList.config.defaultCellPadding)
            local template = _.get(self.columnConfig, {colName, "template"}, "GreatVaultListTableCellTextTemplate")
			local tooltip =  _.get(self.columnConfig, {colName, "tooltip"}, nil)
			local canSort = _.get(self.columnConfig, {colName, "header", "canSort"}, false)
			if canSort then 
				table.insert(self.sortHeaders, idx);
			end

			local col
			if useFill then
				col = tableBuilder:AddFillColumn(owner, 0, width, padding, padding, idx, template, tooltip, idx, self.columns, self.columnConfig, width);
			else
				col = tableBuilder:AddFixedWidthColumn(owner, 0, width, padding, padding, idx, template, tooltip, idx, self.columns, self.columnConfig, width);
			end
			col:GetHeaderFrame():SetText(headerText);
			
			if colName ~= "character" then  return end		
        end)
    end

    return LayoutBrowseListTableBuilder;
end

function GreatVaultListListMixin:OnLoad()

	self.tframe = self.tframe or CreateFrame("Frame", nil, self, "GreatVaultListTableCellTextTemplate")
	self.tframe:Hide()

	self.sortHeaders = {}
	self.sort = -1
	self.reverseSort = false
	self.headers = {}

end


function GreatVaultListListMixin:OnShow()
	if not self.columns then return end
	
	local width = 15 + (_.size(self.columnConfig) * 1)
    _.forEach(self.columnConfig, function(entry)
        width = width + (entry.width or 0)
    end)

    self:GetParent():UpdateSize(width);

	self.ItemList:RefreshScrollFrame();
end


function GreatVaultListListMixin:RegisterHeader(header)
	local find = _.find(self.sortHeaders, function(entry) return entry == header.sortOrder; end)
	if find and  find > 0 then 
		table.insert(self.headers, header);
	end
end


function GreatVaultListListMixin:SetSortOrder(sortOrder, main)
	local asserttext = "variable \"%s\" size is 0"
	GreatVaultList:assert(_.size(self.columns) > 0, "GreatVaultListListMixin:SetSortOrder", asserttext, "self.columns")
	GreatVaultList:assert(_.size(self.columnConfig) > 0, "GreatVaultListListMixin:SetSortOrder", asserttext, "self.columnConfig")

	self.reverseSort =  (self.sort == sortOrder) and not self.reverseSort
	self.sort = sortOrder
		
	for i, header in ipairs(self.headers) do
		header:UpdateArrow(self.reverseSort);
	end

	local comp = (self.reverseSort) and _.gt or _.lt
	local defaultSortFn = function(a, b, comp) return comp(a, b) end
	local sortFn = _.get(self.columnConfig, {self.columns[self.sort], "sortFn"}, defaultSortFn)
	
	sort(self.ItemList.data, function(a, b)
		if not a[self.sort] then return false end
		if not b[self.sort] then return false end
		return sortFn(a[self.sort], b[self.sort], comp)
	end)

	if main then
		GreatVaultList.db.global.sort = self.sort
	end
	self.ItemList:RefreshScrollFrame();
end


function GreatVaultListListMixin:calcAutoWidthColumns(data, columnConfig, columns)
	
	return _.forEach(columnConfig, function(column, key)
		if not column.autoWidth then return column end

		local addSpace = column.header.canSort and 12 or 0
		self.tframe.Text:SetText(column.header.text)
		local maxWidth = math.ceil(self.tframe.Text:GetStringWidth()) + addSpace -- addSpace for arrow 

		_.forEach(data, function(entry)
			self.tframe:Init(self, column.index, columns, columnConfig)
			self.tframe:Populate(entry, column.index)
			local w = math.ceil(self.tframe.Text:GetStringWidth())
			maxWidth = w > maxWidth and w or maxWidth
		end)

		column.width = maxWidth + ( (column.padding or GreatVaultList.config.defaultCellPadding ) * 2)
		return column
	end)
end


function GreatVaultListListMixin:UpdateFilteredData(str)
	str = str and strtrim(string.lower(str)) or nil
	if str then 
		self.ItemList.data = _.filter(self.data, function(entry) 
			return 	entry.enabled 
					and 
					string.find(string.lower(entry.name), str, 0, true)
		end)
	else
		self.ItemList.data = _.filter(self.data, function(entry) return entry.enabled end)
	end
end

function GreatVaultListListMixin:init(columns, data, columnConfig, refresh)
	local asserttext = "variable \"%s\" size is 0"
	GreatVaultList:assert(_.size(columns) > 0, "GreatVaultListListMixin:init", asserttext, "columns")
	GreatVaultList:assert(_.size(data) > 0, "GreatVaultListListMixin:init", asserttext, "data")
	GreatVaultList:assert(_.size(columnConfig) > 0, "GreatVaultListListMixin:init", asserttext, "columnConfig")

    self.columns = columns
	self.data = data
	self:UpdateFilteredData()
    self.columnConfig = columnConfig

	self.columnConfig = self:calcAutoWidthColumns(self.ItemList.data, self.columnConfig, self.columns)

    local width = 15 + (_.size(self.columnConfig) * 1)
    _.forEach(self.columnConfig, function(entry)
        width = width + (entry.width or 0)
    end)

    self:GetParent():UpdateSize(width);

    self.ItemList:SetTableBuilderLayout(self:GetBrowseListLayout(self, self.ItemList, false), self.columnConfig);
	if refresh then 
		self:SetSortOrder(GreatVaultList.db.global.sort, true)
	else
		self.ItemList:RefreshScrollFrame();
	end


end






GreatVaultListListSearchBoxMixin = {}


function GreatVaultListListSearchBoxMixin:OnLoad()
	SearchBoxTemplate_OnLoad(self);
	self.clearButton:SetScript("OnClick", function(btn)
		self:Reset()
		SearchBoxTemplateClearButton_OnClick(btn);
	end)
end

function GreatVaultListListSearchBoxMixin:OnEnterPressed()
	self:GetParent():UpdateFilteredData(self:GetText())
	self:GetParent().ItemList:RefreshScrollFrame();
end

function GreatVaultListListSearchBoxMixin:Reset()
	self:SetText("");
	self:GetParent():UpdateFilteredData()
	self:GetParent().ItemList:RefreshScrollFrame();
end


GreatVaultListListFilterMixin = {}

function GreatVaultListListFilterMixin:OnLoad()
	WowStyle1FilterDropdownMixin.OnLoad(self);
	self.init = false
end

function GreatVaultListListFilterMixin:OnShow()
	if self.init then return end
	self.init = true

	local function IsSelected(filter)
		local find = _.find(GreatVaultList.db.global.characters, function(entry)
			return entry.name == filter
		end)
		if find == nil then return  end
		if find.enabled == nil then return true end
		return find.enabled;
	end
	
	local function SetSelected(filter)
		local find = _.find(GreatVaultList.db.global.characters, function(entry) return entry.name == filter end)

		find.enabled = not find.enabled
		local findItemList = _.find(self:GetParent().data, function(entry) return entry.name == filter end)

		findItemList.enabled = find.enabled
		self:GetParent():UpdateFilteredData()
		self:GetParent().ItemList:RefreshScrollFrame();
		self:GetParent().Search:Reset();
	end

	self:SetupMenu(function(dropdown, rootDescription)
		rootDescription:SetTag("MENU_GREATVAULTLIST_FILTER");
		_.forEach(GreatVaultList.db.global.characters, function(char, key)
			rootDescription:CreateCheckbox(char.name, IsSelected, SetSelected, char.name);
		end)
	end);
end