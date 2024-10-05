local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()

ColumnOrderSettingsMixin = CreateFromMixins(SettingsControlMixin);


function ColumnOrderSettingsMixin:OnLoad()
	SettingsControlMixin.OnLoad(self);
	self.dataTable = {}
	self.dataObj = {}
	self.Text:SetPoint("TOP", 0, -5)
	self.entryHeight = 40
	self.pool = CreateFramePool("BUTTON", self.Content, "ColumnOrderSettingsEntryTemplate");
	self.Interval = nil
	self.init = false
end


function ColumnOrderSettingsMixin:Init(initializer)
	SettingsControlMixin.Init(self, initializer);
	if self.init  then return end
	self.init = true

	local num = #GreatVaultList.ModuleColumns
	self:SetHeight(num * 40)

	local setting = self:GetSetting();
	local currentValue = setting:GetValue()

	self.dataObj = {}
	_.forEach(GreatVaultList.ModuleColumns, function(entry, key)
		self.dataObj[entry.key] = { 
			active = true,
			index = entry.config.defaultIndex, 
			defaultIndex = entry.config.defaultIndex, 
			id = entry.key,
			name =  entry.config.header.text
		}
    end)

	self.dataTable = currentValue

	if not self.dataTable then return end
	self.pool:ReleaseAll();
	
	local sorted  = _.sortBy(CopyTable(self.dataTable), function(a) return a.index end)
	sort(sorted, function(a,b) return a.index< b.index end)

	local i = 0
	_.forEach(sorted, function(item, key)
		i =  i + 1
		if not self.dataObj[item.id] then return end
		local frame = self.pool:Acquire();
		frame:SetPoint("TOPLEFT", self.Content, "TOPLEFT", 0, (i - 1) * self.entryHeight *-1)
		frame:SetText(self:getName(self.dataObj[item.id].name, item.id))
		frame.Checkbox:SetChecked(item.active)
		frame.data = self.dataObj[item.id]
		frame.key = item.id
		frame:Show()
		item.index = i
	end)
end

function ColumnOrderSettingsMixin:OnSettingValueChanged(setting, value)
	SettingsControlMixin.OnSettingValueChanged(self, setting, value)





	_.forEach(value, function(entry, key)
		self.dataTable[entry.id].index = entry.index
	end)

	DevTool:AddData(self.dataTable, "self.dataTable")

	self:UpdatePositionsOnDrag(nil, true)







	-- self.dataTable
	-- local tempWidgets = {}
	-- for widget in self.pool:EnumerateActive() do
	-- 	local defaultValue = value[widget.key]
	-- 	widget.data.index = defaultValue.index
	-- 	tempWidgets[widget.data.index] = widget
	-- end

	-- local widgets = {}
	-- _.forEach(tempWidgets, function(widget, key)
	-- 	table.insert(widgets, widget)
	-- end)

	-- local i = 0
	-- _.forEach(widgets, function(widget, key)
	-- 	i = i + 1
	-- 	widget:ClearAllPoints()
	-- 	widget:SetPoint("TOPLEFT", 0, (i - 1) * self.entryHeight *-1)
	-- 	self.dataTable[widget.data.id].index = widget.data.index
	-- end)
end

function ColumnOrderSettingsMixin:getName(name, id)
	return string.format("%s (%s)", name, id)
end

function ColumnOrderSettingsMixin:Release()
	SettingsControlMixin.Release(self);
end

function ColumnOrderSettingsMixin:StartDrag(id)
	local x, y = GetCursorPosition()
	self.startCursor = y
	self.Interval = C_Timer.NewTicker(.1, function()
		self:UpdatePositionsOnDrag(id)
	end)
end

function ColumnOrderSettingsMixin:StopDrag(id)
	self.Interval:Cancel()
	self:UpdatePositionsOnDrag(id, true)
end


function ColumnOrderSettingsMixin:getPositionOffset()
	if not self.startCursor then return 0 end

	local function round(num, numDecimalPlaces)
		local mult = 10^(numDecimalPlaces or 0)
		return math.floor(num * mult + 0.5) / mult
	end

	local scale = SettingsPanel:GetScale()
	local x, y = GetCursorPosition()
	local position = round((((self.startCursor - y) * 1.6) / scale) / self.entryHeight)

	return position
end

function ColumnOrderSettingsMixin:UpdatePositionsOnDrag(id, finish)
	local tempWidgets = {}
	local activeWidget =  nil
	
	for widget in self.pool:EnumerateActive() do
		if widget.data.id ~= id then
			tempWidgets[self.dataTable[widget.data.id].index] = widget
		else
			activeWidget = widget
		end
	end

	local widgets = {}
	_.forEach(tempWidgets, function(widget, key)
		table.insert(widgets, widget)
	end)

	if activeWidget then
		local newposition = activeWidget.data.index + self:getPositionOffset()
		table.insert(widgets, newposition, activeWidget)
	end


	local i = 0
	_.forEach(widgets, function(widget, key)
		i = i + 1
		if id and widget.data.id == id and not finish then return end
		widget:ClearAllPoints()
		widget:SetPoint("TOPLEFT", 0, (i-1) * self.entryHeight *-1)

		if not id then return end
		widget.data.index = i
		widget:SetText(self:getName(widget.data.name, widget.data.id))
		self.dataTable[widget.key].index = widget.data.index
	end)


	if not finish or not id then return end 



	local initializer = self:GetElementData();
	local setting = initializer:GetSetting();
	setting:SetValue(self.dataTable);
end





ColumnOrderSettingsEntryMixin = {}

function ColumnOrderSettingsEntryMixin:OnLoad()

	self.parent = self:GetParent():GetParent()

	self:SetMovable(true)
    self:EnableMouse(true)
	self:RegisterForDrag("LeftButton")

	
end

function ColumnOrderSettingsEntryMixin:SetState(state)
	self.data.active = state
end



function ColumnOrderSettingsEntryMixin:OnDragStart()
	self.fs = self:GetFrameStrata()
	self:SetFrameStrata("DIALOG")

	self:StartMoving()
	self.parent:StartDrag(self.data.id)

end


function ColumnOrderSettingsEntryMixin:OnDragStop()
	self:SetFrameStrata(self.fs)
	self:StopMovingOrSizing()
	self.parent:StopDrag(self.data.id)
end









ColumnOrderSettingsEntryCheckboxMixin = {}

function ColumnOrderSettingsEntryCheckboxMixin:OnClick()
	print("click", self:GetChecked())

	self:GetParent():SetState(self:GetChecked())
end




function Settings.CreateColumnOrder(category, setting, tooltip)
    local initializer = Settings.CreateControlInitializer("ColumnOrderSettingsTemplate", setting, nil, tooltip);
    local layout = SettingsPanel:GetLayout(category);
	layout:AddInitializer(initializer);
    return initializer;
end









