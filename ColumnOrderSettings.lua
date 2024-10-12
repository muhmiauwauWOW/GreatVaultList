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

	self.options = initializer:GetOptions();

	local num = _.size(self.options)
	self:SetHeight(num * 40)

	local setting = self:GetSetting();
	local currentValue = setting:GetValue()

	self.dataTable = _.forEach(currentValue, function(entry, key)
		entry.id = key
		return entry
	end)

	if not self.dataTable then return end
	self.pool:ReleaseAll();
	
	local sorted  = _.sortBy(CopyTable(self.dataTable), function(a) return a.index end)
	sort(sorted, function(a, b) return a.index < b.index end)

	local i = 0
	_.forEach(sorted, function(item, key)
		i =  i + 1
		local frame = self.pool:Acquire();
		self:frameSetPoint(frame, i)
		frame:SetText(self:getName(self.options[item.id]))
		frame.Checkbox:SetChecked(item.active)
		frame.key = item.id
		frame:Show()
	end)
end

function ColumnOrderSettingsMixin:OnSettingValueChanged(setting, value)
	SettingsControlMixin.OnSettingValueChanged(self, setting, value)

	_.forEach(value, function(entry, key)
		self.dataTable[entry.id] = CopyTable(entry)
	end)

	self:UpdatePositionsOnDrag(nil, true)
end

function ColumnOrderSettingsMixin:getName(entry)
	if not entry then return "" end
	return string.format("%s (%s)", entry.name, entry.id)
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
		if not self.dataTable[widget.key] then return end
		widget.Checkbox:EvaluateState(self.dataTable[widget.key].active)
		if widget.key ~= id then
			tempWidgets[self.dataTable[widget.key].index] = widget
		else
			activeWidget = widget
		end
	end

	local widgets = {}
	_.forEach(tempWidgets, function(widget, key)
		table.insert(widgets, widget)
	end)

	if activeWidget then
		local newposition = self.dataTable[activeWidget.key].index + self:getPositionOffset()
		table.insert(widgets, newposition, activeWidget)
	end

	local i = 0
	_.forEach(widgets, function(widget, key)
		i = i + 1
		if id and widget.key == id and not finish then return end
		self:frameSetPoint(widget, i)
		if not id then return end
		self.dataTable[widget.key].index = i
	end)


	if not finish or not id then return end 

	self:Save()
end

function ColumnOrderSettingsMixin:frameSetPoint(frame, position)
	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT", 0, (position - 1) * self.entryHeight * -1)
end



function ColumnOrderSettingsMixin:SetActiveState(key, state)
	self.dataTable[key].active = state
	self:Save()
end


function ColumnOrderSettingsMixin:Save()
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
	self.parent:SetActiveState(self.key, state)
end



function ColumnOrderSettingsEntryMixin:OnDragStart()
	self.fs = self:GetFrameStrata()
	self:SetFrameStrata("DIALOG")

	self:StartMoving()
	self.parent:StartDrag(self.key)

end


function ColumnOrderSettingsEntryMixin:OnDragStop()
	self:SetFrameStrata(self.fs)
	self:StopMovingOrSizing()
	self.parent:StopDrag(self.key)
end



ColumnOrderSettingsEntryCheckboxMixin = {}

function ColumnOrderSettingsEntryCheckboxMixin:OnClick()
	self:GetParent():SetState(self:GetChecked())
end


function ColumnOrderSettingsEntryCheckboxMixin:EvaluateState(state)
	self:SetChecked(state)
end




function Settings.CreateColumnOrder(category, setting, options, tooltip)
    local initializer = Settings.CreateControlInitializer("ColumnOrderSettingsTemplate", setting, options, tooltip);
    local layout = SettingsPanel:GetLayout(category);
	layout:AddInitializer(initializer);
    return initializer;
end









