local ColumKey = "pvp"
local Column = GreatVaultAddon:NewModule("GREATVAULTLIST_COLUMNS_" .. ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultAddon:GetLibs()

Column.key = ColumKey
Column.config = {
    ["index"] = 10,
    ["header"] =  { key = ColumKey, text = L[ColumKey], width = 100, canSort = false, dataType = "string", order = "DESC", offset = 50, align = "center"},
    ["subCols"] = 3,
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = ColumKey,
    },
    ['emptyStr'] = {
        "0/1250",
        "0/2500",
        "0/5000"
    },
    ["store"] = function(characterInfo)
        characterInfo.pvp = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.RankedPvP)
        return characterInfo
    end
}