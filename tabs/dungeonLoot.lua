local addonName = ...
local L, _ = GreatVaultList:GetLibs()


local TabID = "dungeonLoot"
local Tab = GreatVaultList:NewModule(TabID, GREATVAULTLIST_TABS)

Tab.id = TabID
Tab.name = string.format(L["tabLoot_name"], DUNGEONS)
Tab.template = "GreatVaultListDungeonLootTemplate"



GreatVaultListDungeonLootListMixin  = CreateFromMixins(GreatVaultListLootListMixin);

GreatVaultListDungeonLootListMixin.id = TabID
GreatVaultListDungeonLootListMixin.tabName = Tab.name
GreatVaultListDungeonLootListMixin.sortOrder = 4

function GreatVaultListDungeonLootListMixin:OnLoad()
	GreatVaultListLootListMixin.OnLoad(self)
	-- GreatVaultList.ElvUi:AddTab(self)
end

function GreatVaultListDungeonLootListMixin:GetHelpConfig()

	local width = self:GetWidth()
	local height = self:GetHeight() + 50



	local helpConfig = {
		FramePos = { x = 0, y = 0 },
		FrameSize = { width = width, height = height },
		[1] = { ButtonPos = { position = "CENTER" }, HighLightBox = { x = 5, y = -40, width = width + 10 , height = height - 40 - 5 - 50 },  ToolTipDir = "RIGHT",   ToolTipText = L["HELP_Loot_table"] },
	}

	return helpConfig
end

function GreatVaultListDungeonLootListMixin:BuildData()
	
	self:AddColumn(L["dungeonLoot_col1"])
	self:AddColumn(L["tabLoot_ilvl"], true, L["dungeonLoot_col2"])
	self:AddColumn(L["tabLoot_upgradelvl"], true, L["dungeonLoot_col2"])
	self:AddColumn(L["tabLoot_ilvl"], true, L["tabLoot_greatVault"])
	self:AddColumn(L["tabLoot_upgradelvl"], false, L["tabLoot_greatVault"])



	self.ItemList.data = {
		{ 
			PLAYER_DIFFICULTY2,
			619,
			L["gearTrack_Adventurer"] .. " 4/8",
			632,
			L["gearTrack_Veteran"] .. " 4/8"
		},
		{ 
			PLAYER_DIFFICULTY6,
			632,
			L["gearTrack_Veteran"] .. " 4/8",
			642,
			L["gearTrack_Champion"] .. "  3/8"
		},
		{
			2,
			639,
			L["gearTrack_Champion"] .. " 2/8",
			649,
			L["gearTrack_Hero"] .. " 1/6"
		},
		{
			3,
			639,
			L["gearTrack_Champion"] .. " 2/8",
			649,
			L["gearTrack_Hero"] .. " 1/6"
		},
		{
			4,
			642,
			L["gearTrack_Champion"] .. " 3/8",
			652,
			L["gearTrack_Hero"] .. " 2/6"
		},
		{
			5,
			645,
			L["gearTrack_Champion"] .. " 4/8",
			652,
			L["gearTrack_Hero"] .. " 2/6"
		},
		{
			6,
			649,
			L["gearTrack_Hero"] .. " 1/6",
			655,
			L["gearTrack_Hero"] .. " 3/6"
		},
		{
			7,
			649,
			L["gearTrack_Hero"] .. " 1/6",
			658,
			L["gearTrack_Hero"] .. " 4/6"
		},
		{
			8,
			652,
			L["gearTrack_Hero"] .. " 2/6",
			658,
			L["gearTrack_Hero"] .. " 4/6"
		},
		{
			9,
			652,
			L["gearTrack_Hero"] .. " 2/6",
			658,
			L["gearTrack_Hero"] .. " 4/6"
		},
		{
			10,
			655,
			L["gearTrack_Hero"] .. " 3/6",
			662,
			L["gearTrack_Myth"] .. " 1/6"
		},
	}


end
