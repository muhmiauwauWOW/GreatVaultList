local ColumKey = "raid"
local Column = GreatVaultAddon:NewModule("GREATVAULTLIST_COLUMNS_" .. ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultAddon:GetLibs()

Column.key = ColumKey
Column.config = {
    ["index"] = 4,
    ["header"] =  { key = ColumKey, text = L[ColumKey], width = 40, canSort = false, dataType = "string", order = "DESC", offset = 20, align = "center"},
    ["subCols"] = 3,
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = "averageItemLevel",
    },
    ['emptyStr'] = {
        "0/2",
        "0/4",
        "0/6"
    },
    event = {
        {"WEEKLY_REWARDS_UPDATE", "WEEKLY_REWARDS_ITEM_CHANGED"},
        function(self)
            self.config.store(GreatVaultAddon.data:get())
            if GreatVaultInfoFrame:IsShown() then  -- refresh view if window is open
                GreatVaultAddon.ScrollFrame.ScollFrame:Refresh()
            end
        end
    },
    ["store"] = function(characterInfo)
        characterInfo.raid = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.Raid)
        return characterInfo
    end
}