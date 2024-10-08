local addonName = ...
local L, _ = GreatVaultList:GetLibs()

local delvesLootMixin  = CreateFromMixins(GreatVaultListLootListMixin);
GreatVaultListDelvesLootListMixin = delvesLootMixin

delvesLootMixin.tabName = string.format(L["tabLoot_name"], DELVES_LABEL)
delvesLootMixin.sortOrder = 1


function delvesLootMixin:OnLoad()
	GreatVaultListLootListMixin.OnLoad(self)
end

function delvesLootMixin:OnShow()
	GreatVaultListLootListMixin.OnShow(self)

	-- Restored Coffer Key
	local info = C_CurrencyInfo.GetCurrencyInfo(3028)
	local color = info.quantity == 0 and RED_FONT_COLOR or GREEN_FONT_COLOR
	self.keys.Text:SetText(string.format("%s: %s", NORMAL_FONT_COLOR:WrapTextInColorCode(info.name),  color:WrapTextInColorCode(tostring(info.quantity))))
	self.keys:SetWidth(self.keys.Text:GetUnboundedStringWidth() + 20)
end

function delvesLootMixin:BuildData()

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
