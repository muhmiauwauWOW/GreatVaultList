local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()

ColumnOrderSettingsMixin = CreateFromMixins(SettingsControlMixin);


function ColumnOrderSettingsMixin:OnLoad()
	SettingsControlMixin.OnLoad(self);
	self.dataTable = {}
	self.Text:SetPoint("TOP", 0, -5)

	self.pool = CreateFramePool("BUTTON", self.Content, "ColumnOrderSettingsEntryTemplate");

	self.Interval = nil
end

function ColumnOrderSettingsMixin:SetValueFn(key, value)
	if not self.dataTable then return end
	self.dataTable[key] = value
	self:GetSetting():SetValue(self.dataTable)
end

function ColumnOrderSettingsMixin:Init(initializer)
	SettingsControlMixin.Init(self, initializer);
	local setting = self:GetSetting();
	local currentValue = setting:GetValue()

	self.dataTable = currentValue

	self.pool:ReleaseAll();

	if not self.dataTable then return end


    -- DevTool:AddData(self.dataTable, "(self.dataTable,")
	-- self.dataTable = _.sortBy(self.dataTable, function(a) return a.index end)
	-- DevTool:AddData(self.dataTable, "(self.dataTable,")

	local i = 0

	_.forEach(self.dataTable, function(item, key)
		print(key, item.index)
		local frame = self.pool:Acquire();
		frame:SetPoint("TOPLEFT", self.Content, "TOPLEFT", 0, i * 19 *-1)
		frame:SetText(key .. " ".. item.name.. " ".. item.index)
		frame.Checkbox:SetChecked(item.active)
		frame.id = item.id

		frame.Arrow:Hide()
		frame:Show()
		i =  i + 1
		item.index = i
		frame.index = item.index
		frame.name = item.name
	end)



	

	-- self.AtlasName:SetText(self.dataTable.atlas)
    -- self.Atlas.NormalTexture:SetAtlas(self.dataTable.atlas)
	-- self.Atlas.HighlightTexture:SetAtlas(self.dataTable.atlas)

	-- self.X:SetText(self.dataTable.x)
	-- self.Y:SetText(self.dataTable.y)

end

function ColumnOrderSettingsMixin:OnSettingValueChanged(setting, value)
	SettingsControlMixin.OnSettingValueChanged(self, setting, value)
	-- self.AtlasName:SetText(value.atlas)
	-- self.Atlas.NormalTexture:SetAtlas(value.atlas)
	-- self.Atlas.HighlightTexture:SetAtlas(value.atlas)
	-- self.X:SetText(value.x)
	-- self.Y:SetText(value.y)
end

function ColumnOrderSettingsMixin:Release()
	SettingsControlMixin.Release(self);
end



function ColumnOrderSettingsMixin:ChangeEntry(id, key, value )
	local find = _.find(self.dataTable, function(entry)
		return entry.id == id
	end)
	if not find then return end
	find[key] = value

	print(id, key, value)
	DevTool:AddData(self.dataTable, "ChangeEntry")

end

function ColumnOrderSettingsMixin:OnReceiveDrag()
	print("OnReceiveDrag parent")
end


function ColumnOrderSettingsMixin:StartDrag(id)
	local x, y = GetCursorPosition()
	self.startCursor = y
	self.Interval = C_Timer.NewTicker(1, function()

	--	self:UpdatePositionsOnDrag(id)
		print("initval")
	
	end)
end

function ColumnOrderSettingsMixin:StopDrag(id)
	self.Interval:Cancel()

	local x, y = GetCursorPosition()
	local position =  math.floor((self.startCursor - y)*2/ 19)


	-- position
	-- print("position",position, find.index )

	
	local widgets = {}
	local active =  nil
	
	for widget in self.pool:EnumerateActive() do
		if widget.id ~= id then
			widgets[widget.index] = widget
		else
			active = widget
		end
	end
	local newposition = active.index + position
	table.insert(widgets, newposition, active)

	local i = 0
	_.forEach(widgets, function(widget, key)
		widget:ClearAllPoints()
		widget:SetPoint("TOPLEFT", 0, i * 19 *-1)
		widget.index = i + 1
		widget:SetText(i .. " ".. widget.name.. " ".. widget.index)
		i = i + 1
	end)
end


function ColumnOrderSettingsMixin:UpdatePositionsOnDrag(id)
	-- print("lolo", id)

	local widgets = {}
	
	for widget in self.pool:EnumerateActive() do
		if widget.id ~= id then
			-- print(widget.index, widget.id)
			widgets[widget.index] = widget
		end
	end

	DevTool:AddData(self.startCursor - y, "y")
	DevTool:AddData(widgets)
	local i = 0
	_.forEach(widgets, function(widget)
		widget:ClearAllPoints()
		widget:SetPoint("TOPLEFT", 0, i * 19 *-1)
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
	print("i am active?", state)
	self.parent:ChangeEntry(self.id, "active", state )
end



function ColumnOrderSettingsEntryMixin:OnDragStart()
	print("OnDragStart")

	self:StartMoving()
	self.parent:StartDrag(self.id)

end


function ColumnOrderSettingsEntryMixin:OnDragStop()
	print("OnDragStop")
	self:StopMovingOrSizing()
	self.parent:StopDrag(self.id)
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









