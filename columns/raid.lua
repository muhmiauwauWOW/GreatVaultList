local Column = GreatVaultAddon:NewModule("GREATVAULTLIST_COLUMNS_raid", GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultAddon:GetLibs()


Column.key = "raid"

Column.config = {
    ["index"] = 4,
    ["header"] =  { key = "raid", text = L["Raids"], width = 40, canSort = false, dataType = "string", order = "DESC", offset = 20, align = "center"},
    ["subCols"] = 3,
    ["sort"] = {
        ["key"] = "raid",
        ["store"] = "averageItemLevel",
    },
    ["store"] = function(characterInfo)
        characterInfo.raid = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.Raid)
        return characterInfo
    end
}