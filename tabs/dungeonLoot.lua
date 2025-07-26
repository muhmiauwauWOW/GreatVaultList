local addonName = ...
local L, _ = GreatVaultList:GetLibs()

local TabID = "dungeonLoot"
local Tab = GreatVaultList:NewModule(TabID, GREATVAULTLIST_TABS)

Tab.id = TabID
Tab.name = string.format(L["tabLoot_name"], DUNGEONS)
Tab.template = "GreatVaultListDungeonLootTemplate"

GreatVaultListDungeonLootListMixin = CreateFromMixins(
                                         GreatVaultListLootListMixin);

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
        FramePos = {x = 0, y = 0},
        FrameSize = {width = width, height = height},
        [1] = {
            ButtonPos = {position = "CENTER"},
            HighLightBox = {
                x = 5,
                y = -40,
                width = width + 10,
                height = height - 40 - 5 - 50
            },
            ToolTipDir = "RIGHT",
            ToolTipText = L["HELP_Loot_table"]
        }
    }

    return helpConfig
end

function GreatVaultListDungeonLootListMixin:BuildData()

    self:AddColumn(L["dungeonLoot_col1"])
    self:AddColumn(L["tabLoot_ilvl"], true, L["dungeonLoot_col2"])
    self:AddColumn(L["tabLoot_upgradelvl"], true, L["dungeonLoot_col2"])
    self:AddColumn(L["tabLoot_ilvl"], true, L["tabLoot_greatVault"])
    self:AddColumn(L["tabLoot_upgradelvl"], false, L["tabLoot_greatVault"])
    self:AddColumn(L["tabLoot_crests"], false, L["tabLoot_crests_desc"])




	local function buildEntry(lvl, ilvl1, ilvl2, crest, crestamount)
		local crestIcons = GreatVaultList.itemlvl:GetCrestIconByKey(crest)
		local crests = crestIcons
		if crestamount then
			crests = string.format("%sx%d", crestIcons, crestamount)
		end

		local entry = {
			lvl,
			ilvl1,
			GreatVaultList.itemlvl:GetHighestTrackString(ilvl1, false),
			ilvl2,
			GreatVaultList.itemlvl:GetHighestTrackString(ilvl2, false),
			crests
		};

		return entry
	end
	

    self.ItemList.data = {
        buildEntry(PLAYER_DIFFICULTY2, 665, 678, "weathered"),
        buildEntry(PLAYER_DIFFICULTY2, 665, 678, "weathered"),
        buildEntry(PLAYER_DIFFICULTY6, 681, 691, "carved"),
        buildEntry(2, 684, 694, "runed", 10),
        buildEntry(3, 684, 694, "runed", 12),
        buildEntry(4, 688, 697, "runed", 14),
        buildEntry(5, 691, 697, "runed", 16),
        buildEntry(6, 694, 701, "runed", 18),
        buildEntry(7, 694, 704, "gilded", 10),
        buildEntry(8, 697, 704, "gilded", 12),
        buildEntry(9, 697, 704, "gilded", 14),
        buildEntry(10, 701, 707, "gilded", 16),
        buildEntry(11, 701, 707, "gilded", 18),
        buildEntry("12+", 701, 707, "gilded", 20)
    }

end
