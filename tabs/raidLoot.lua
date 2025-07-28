local addonName = ...
local _ = LibStub("LibLodash-1"):Get()
local L, _ = GreatVaultList:GetLibs()


local TabID = "raidLoot"
local Tab = GreatVaultList:NewModule(TabID, GREATVAULTLIST_TABS)

Tab.id = TabID
Tab.name = string.format(L["tabLoot_name"], RAIDS)
Tab.template = "GreatVaultListRaidLootTemplate"


GreatVaultListRaidLootListMixin  = CreateFromMixins(GreatVaultListLootListMixin);

GreatVaultListRaidLootListMixin.id = TabID
GreatVaultListRaidLootListMixin.tabName = Tab.name
GreatVaultListRaidLootListMixin.sortOrder = 5


function GreatVaultListRaidLootListMixin:OnLoad()
	GreatVaultListLootListMixin.OnLoad(self)
	-- GreatVaultList.ElvUi:AddTab(self)
end

function GreatVaultListRaidLootListMixin:GetHelpConfig()

	local width = self:GetWidth()
	local height = self:GetHeight() + 50



	local helpConfig = {
		FramePos = { x = 0, y = 0 },
		FrameSize = { width = width, height = height },
		[1] = { ButtonPos = { position = "CENTER" }, HighLightBox = { x = 5, y = -40, width = width + 10 , height = height - 40 - 5 - 50 },  ToolTipDir = "RIGHT",   ToolTipText = L["HELP_Loot_table"] },
	}

	return helpConfig
end

function GreatVaultListRaidLootListMixin:BuildData()
	self:AddColumn(L["raidLoot_col1"])
	self:AddColumn(string.format(L["raidLoot_bosses"], "1-3"), true)
	self:AddColumn(string.format(L["raidLoot_bosses"], "4-6"), true)
	self:AddColumn(string.format(L["raidLoot_bosses"], "7-8"), true)
	self:AddColumn(L["tabLoot_crestType"], false, L["tabLoot_crestType_desc"])

	local function buildEntry(type, ilvl1, ilvl2, ilvl3, crest)

		local entry = {
			type,
			ilvl1,
			ilvl2,
			ilvl3,
			GreatVaultList.itemlvl:GetCrestIconByKey(crest, true)
		};

		return entry
	end

	self.ItemList.data = {
        buildEntry(string.format("%s %s", "LFR", L["raidLoot_Regular"]), 671, 675, 678, "weathered"),
        buildEntry(string.format("%s %s", "Normal", L["raidLoot_Regular"]), 684, 688, 691, "carved"),
        buildEntry(string.format("%s %s", "Heroic", L["raidLoot_Regular"]), 697, 701, 704, "runed"),
        buildEntry(string.format("%s %s", "Mythic", L["raidLoot_Regular"]), 710, 714, 717, "gilded")
    }
end
