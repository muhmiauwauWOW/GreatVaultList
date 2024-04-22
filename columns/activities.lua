local Column = GreatVaultAddon:NewModule("GREATVAULTLIST_COLUMNS_activities", GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultAddon:GetLibs()

local CONST_SCROLL_LINE_HEIGHT = 20

Column.key = "activities"

Column.config = {
    ["index"] = 7,
    ["header"] =  { key = "activities", text = L["activities"], width = 40, canSort = false, dataType = "string", order = "DESC", offset = 20, align = "center"},
    ["subCols"] = 3,
    ["sort"] = {
        ["key"] = "activities",
        ["store"] = "averageItemLevel",
    },
    ["store"] = function(characterInfo)
        characterInfo.activities = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.Activities)
        return characterInfo
    end
}