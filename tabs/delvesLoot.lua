local addonName = ...
local L, _ = GreatVaultList:GetLibs()


local TabID = "delvesLoot"
local Tab = GreatVaultList:NewModule(TabID, GREATVAULTLIST_TABS)

Tab.id = TabID
Tab.name = string.format(L["tabLoot_name"], DELVES_LABEL)
Tab.template = "GreatVaultListDelvesLootTemplate"


GreatVaultListDelvesLootListMixin  = CreateFromMixins(GreatVaultListLootListMixin);

GreatVaultListDelvesLootListMixin.id = TabID
GreatVaultListDelvesLootListMixin.tabName = Tab.name
GreatVaultListDelvesLootListMixin.sortOrder = 1
GreatVaultListDelvesLootListMixin.keysInit = false

function GreatVaultListDelvesLootListMixin:OnLoad()
	GreatVaultListLootListMixin.OnLoad(self)
	local keysState = GreatVaultList.db.global.Options.tabs[self.id].showKeys
	self:SetKeysState(keysState)
	-- GreatVaultList.ElvUi:AddTab(self)
end

function GreatVaultListDelvesLootListMixin:SetKeysState(state)
	if not self.keys then return end
	if not self.keysInit and not state then return	end

	if not self.keysInit and state then  
		local info = C_CurrencyInfo.GetCurrencyInfo(3028)
		local color = info.quantity == 0 and RED_FONT_COLOR or GREEN_FONT_COLOR
		self.keys.Text:SetText(string.format("%s: %s", NORMAL_FONT_COLOR:WrapTextInColorCode(info.name),  color:WrapTextInColorCode(tostring(info.quantity))))
		self.keys:SetWidth(self.keys.Text:GetUnboundedStringWidth() + 20)
		self.keysInit = true
	end

	self.keys:SetShown(state)
end



function GreatVaultListDelvesLootListMixin:GetHelpConfig()

	local width = self:GetWidth()
	local height = self:GetHeight() + 50

	local info = C_CurrencyInfo.GetCurrencyInfo(3028)
	local test2 = string.format(L["HELP_DelvesLoot_1"], info.name,  info.name)

	local helpConfig = {
		FramePos = { x = 0, y = 0 },
		FrameSize = { width = width, height = height },
		[1] = { ButtonPos = { position = "CENTER" }, HighLightBox = { x = 5, y = -40, width = width + 10 , height = height - 40 - 5 - 50 },  ToolTipDir = "RIGHT",   ToolTipText = L["HELP_Loot_table"] },
	}

	if self.keys:IsShown() then 
		helpConfig[2] = { ButtonPos = { position = "CENTER" },  HighLightBox = { x = width - 210, y = -9, width = 210, height = 30 },	ToolTipDir = "DOWN",  ToolTipText = test2}
	end

	return helpConfig
end

function GreatVaultListDelvesLootListMixin:AddOptions(category)
	local setting = Settings.RegisterAddOnSetting(category, "showKeys", "showKeys", GreatVaultList.db.global.Options.tabs[self.id], "boolean", L["opt_tab_delvesLoot_showKeys_name"], true)
	local s = self
	setting:SetValueChangedCallback(function(self)
		local value = self:GetValue()
		s:SetKeysState(value)
	end)

	Settings.CreateCheckbox(category, setting, L["opt_tab_delvesLoot_showKeys_desc"])
end

function GreatVaultListDelvesLootListMixin:BuildData()

    self:AddColumn(L["delvesLoot_col1"])
	self:AddColumn(L["tabLoot_ilvl"], true, L["delvesLoot_col2"])
	self:AddColumn(L["tabLoot_upgradelvl"], false, L["delvesLoot_col2"])
	self:AddColumn(L["tabLoot_ilvl"], true, L["tabLoot_greatVault"])
	self:AddColumn(L["tabLoot_upgradelvl"], false, L["tabLoot_greatVault"])


	self.ItemList.data = {
		{
			1,
			561,
			L["gearTrack_Explorer"] .. " 2/8",
			584,
			L["gearTrack_Veteran"] .. " 1/8"
		},
		{
			2, 
			564,
			L["gearTrack_Explorer"] .. " 3/8",        
			584,
			L["gearTrack_Veteran"] .. " 1/8"
		},
		{
			3, 
			571,
			L["gearTrack_Explorer"] .. " 1/8",      
			587,
			L["gearTrack_Veteran"] .. " 2/8"
		},
		{
			4, 
			577,
			L["gearTrack_Explorer"] .. " 3/8",      
			597,
			L["gearTrack_Champion"] .. " 1/8"
		},
		{
			5, 
			584,
			L["gearTrack_Veteran"] .. " 1/8",     
			603,
			L["gearTrack_Champion"] .. " 3/8"
		},
		{
			6, 
			590,
			L["gearTrack_Veteran"] .. " 3/8",     
			606,
			L["gearTrack_Champion"] .. " 4/8"
		},
		{
			7, 
			597,
			L["gearTrack_Champion"] .. " 1/8",        
			610,
			L["gearTrack_Hero"] .. " 1/6"
		},
		{
			8, 
			603,
			L["gearTrack_Champion"] .. " 3/8",        
			616,
			L["gearTrack_Hero"] .. " 3/6"
		},
		{
			9, 
			603,
			L["gearTrack_Champion"] .. " 3/8",        
			616,
			L["gearTrack_Hero"] .. " 3/6"
		},
		{
			10,
			603, 
			L["gearTrack_Champion"] .. " 3/8",        
			616,
			L["gearTrack_Hero"] .. " 3/6"
		},
		{
			11,
			603, 
			L["gearTrack_Champion"] .. " 3/8",        
			616, 
			L["gearTrack_Hero"] .. " 3/6"
		},
	}

end
