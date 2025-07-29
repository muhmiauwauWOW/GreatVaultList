local addonName = ...
local L, _ = GreatVaultList:GetLibs()
local LibGearData = LibStub("LibGearData-1.0")


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

	

    self.ItemList.data = LibGearData:GetDungeonLootList()

end
