local addonName = ...
local L, _ = GreatVaultList:GetLibs()




local ListMixin = {};
GreatVaultListListMixin = ListMixin

function ListMixin:GetBrowseListLayout(owner, itemList, useFill)
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

function ListMixin:OnLoad()

	self.tframe = self.tframe or CreateFrame("Frame", nil, self, "GreatVaultListTableCellTextTemplate")
	self.tframe:Hide()

	self.sortHeaders = {}
	self.sort = -1
	self.reverseSort = false
	self.headers = {}

end


function ListMixin:OnShow()
	if not self.columns then return end
	
	local width = 15 + (_.size(self.columnConfig) * 1)
    _.forEach(self.columnConfig, function(entry)
        width = width + (entry.width or 0)
    end)

    self:GetParent():UpdateSize(width);

	self.ItemList:RefreshScrollFrame();
end


function ListMixin:RegisterHeader(header)
	local find = _.find(self.sortHeaders, function(entry) return entry == header.sortOrder; end)
	if find and  find > 0 then 
		table.insert(self.headers, header);
	end
end


function ListMixin:SetSortOrder(sortOrder, main)
	local asserttext = "variable \"%s\" size is 0"
	GreatVaultList:assert(_.size(self.columns) > 0, "ListMixin:SetSortOrder", asserttext, "self.columns")
	GreatVaultList:assert(_.size(self.columnConfig) > 0, "ListMixin:SetSortOrder", asserttext, "self.columnConfig")

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


function ListMixin:calcAutoWidthColumns(data, columnConfig, columns)
	
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


function ListMixin:UpdateFilteredData(str)
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

function ListMixin:init(columns, data, columnConfig, refresh)
	local asserttext = "variable \"%s\" size is 0"
	GreatVaultList:assert(_.size(columns) > 0, "ListMixin:init", asserttext, "columns")
	GreatVaultList:assert(_.size(data) > 0, "ListMixin:init", asserttext, "data")
	GreatVaultList:assert(_.size(columnConfig) > 0, "ListMixin:init", asserttext, "columnConfig")

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
