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
		local frame = self.pool:Acquire();
		frame:SetPoint("TOPLEFT", self.Content, "TOPLEFT", 0, i * self.entryHeight *-1)
		frame:SetText(self:getName(self.dataObj[item.id].name, item.id))
		frame.Checkbox:SetChecked(item.active)
		frame.data = self.dataObj[item.id]
		frame.key = item.id
		frame:Show()
		i =  i + 1
		item.index = i
	end)
end

function ColumnOrderSettingsMixin:OnSettingValueChanged(setting, value)
	SettingsControlMixin.OnSettingValueChanged(self, setting, value)
	
	for widget in self.pool:EnumerateActive() do
		local defaultValue = value[widget.key]
		widget:ClearAllPoints()
		widget:SetPoint("TOPLEFT", 0, (defaultValue.index - 1) * self.entryHeight *-1)
		self.dataTable[widget.key].index = defaultValue.index
	end
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
	-- self.Interval = C_Timer.NewTicker(1, function()

	-- --	self:UpdatePositionsOnDrag(id)
	-- 	--print("initval")
	
	-- end)
end


function ColumnOrderSettingsMixin:StopDrag(id)

	local function round(num, numDecimalPlaces)
		local mult = 10^(numDecimalPlaces or 0)
		return math.floor(num * mult + 0.5) / mult
	  end
	
	-- self.Interval:Cancel()

	local x, y = GetCursorPosition()
	local position = round((self.startCursor - y)*2/ self.entryHeight)


	local tempWidgets = {}
	local activeWidget =  nil
	
	for widget in self.pool:EnumerateActive() do
		if widget.data.id ~= id then
			tempWidgets[widget.data.index] = widget
		else
			activeWidget = widget
		end
	end

	local widgets = {}
	_.forEach(tempWidgets, function(widget, key)
		table.insert(widgets, widget)
	end)

	if not activeWidget then return end
	local newposition = activeWidget.data.index + position
	table.insert(widgets, newposition, activeWidget)

	local i = 0
	_.forEach(widgets, function(widget, key)
		widget:ClearAllPoints()
		widget:SetPoint("TOPLEFT", 0, i * self.entryHeight *-1)
		widget.data.index = i + 1
		widget:SetText(self:getName(widget.data.name, widget.data.id))
		self.dataTable[widget.key].index = widget.data.index
		i = i + 1
	end)
end


function ColumnOrderSettingsMixin:UpdatePositionsOnDrag(id)
		local widgets = {}
	
	for widget in self.pool:EnumerateActive() do
		if widget.id ~= id then
			widgets[widget.index] = widget
		end
	end

	local i = 0
	_.forEach(widgets, function(widget)
		widget:ClearAllPoints()
		widget:SetPoint("TOPLEFT", 0, i * self.entryHeight *-1)
		i = i + 1
	end)
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









