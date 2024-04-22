local Column = GreatVaultAddon:NewModule("GREATVAULTLIST_COLUMNS_pvp", GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultAddon:GetLibs()

local CONST_SCROLL_LINE_HEIGHT = 20

Column.key = "pvp"

Column.config = {
    ["index"] = 10,
    ["header"] =  { key = "pvp", text = L["PvP"], width = 100, canSort = false, dataType = "string", order = "DESC", offset = 50, align = "center"},
    ["subCols"] = 3,
    ["sort"] = {
        ["key"] = "pvp",
        ["store"] = "averageItemLevel",
    },
    ["store"] = function(characterInfo)
        characterInfo.pvp = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.RankedPvP)
        return characterInfo
    end
}