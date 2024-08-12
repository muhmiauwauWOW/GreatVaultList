local ColumKey = "ilevel"
local Column = GreatVaultAddon:NewModule("GREATVAULTLIST_COLUMNS_" .. ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultAddon:GetLibs()

Column.key = ColumKey
Column.config = {
    ["index"] = 3,
    ["header"] = {key = ColumKey, text = L[ColumKey], width = 60, canSort = true, dataType = "number", order = "DESC", offset = 0},
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = "averageItemLevel",
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
        local _, ilvl = GetAverageItemLevel();
        characterInfo.averageItemLevel = ilvl
        return characterInfo
    end,
    ["refresh"] = function(line, data)
        line[ColumKey].text  = string.format("%.2f", data.averageItemLevel)
        return line
    end
}